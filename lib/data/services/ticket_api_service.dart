import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/token_storage.dart';

class TicketApiService {
  late final Dio _dio;

  TicketApiService() {
    _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl, connectTimeout: const Duration(seconds: 30), receiveTimeout: const Duration(seconds: 30), headers: {'Content-Type': 'application/json', 'Accept': 'application/json'}));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorage().getAccessToken();
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
    ));
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, error: true));
  }

  Future<Response> getMyTickets() async => await _dio.get('/bookings');
  Future<Response> getTicketDetail(int bookingId) async => await _dio.get('/bookings/$bookingId');
}