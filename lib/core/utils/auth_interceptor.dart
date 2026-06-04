import 'package:dio/dio.dart';
import 'token_storage.dart';
import '../constants/api_constants.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  AuthInterceptor(this._dio, this._tokenStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token might be expired, try refreshing
      bool refreshed = await _refreshToken();
      if (refreshed) {
        // Retry the original request with new token
        try {
          final accessToken = await _tokenStorage.getAccessToken();
          final opts = Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          );
          if (accessToken != null && accessToken.isNotEmpty) {
            opts.headers?['Authorization'] = 'Bearer $accessToken';
          }
          
          final cloneReq = await _dio.request(
            err.requestOptions.path,
            options: opts,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
          );
          
          return handler.resolve(cloneReq);
        } catch (e) {
          return handler.next(err);
        }
      } else {
        // If refresh fails, clear tokens and pass the error further
        // In a real app, you'd trigger a logout event here
        await _tokenStorage.clearTokens();
        return handler.next(err);
      }
    }
    
    return handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      // Lấy refresh token hiện tại đang lưu trong máy
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) return false;

      // Sử dụng một instance Dio độc lập để tránh vòng lặp vô hạn
      final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
      final response = await refreshDio.post('/auth/refresh-token', data: {
        'refreshToken': refreshToken,
      });

      if (response.statusCode == 200 && response.data != null) {
        // 1. Đi sâu vào tầng 'data' theo đúng chuẩn API trả về của Backend
        final dataBlock = response.data['data'] ?? {};
        
        // 2. Lấy Access Token mới (khớp với key 'accessToken' trong RefreshTokenHandler.js)
        final newAccessToken = dataBlock['accessToken'];

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          // 3. SỬA TẠI ĐÂY: Lưu Access Token mới và GIỮ NGUYÊN Refresh Token cũ vào máy
          await _tokenStorage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: refreshToken, // Dùng lại chính cái token đang có hiệu lực
          );
          return true; // Trả về true để hệ thống tự thực hiện lại request lỗi vừa rồi
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
