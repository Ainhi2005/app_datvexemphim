import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/rating.dart';
import '../../core/constants/api_constants.dart';

class RatingApiService {
  late final Dio _dio;

  RatingApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  /// 💡 Cập nhật Token xác thực động cho các request yêu cầu đăng nhập (POST Create)
  void updateToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// ── Lấy danh sách đánh giá công khai theo ID phim ──
  Future<List<Rating>> getMovieRatings(int movieId) async {
    try {
      // Khớp cấu trúc Route: {{baseUrl}}/movies/:movieId/ratings
      final response = await _dio.get('/movies/$movieId/ratings');

      if (response.statusCode == 200) {
        List<dynamic> ratingsData = [];
        
        if (response.data is Map && response.data.containsKey('data')) {
          ratingsData = response.data['data'];
        } else if (response.data is List) {
          ratingsData = response.data;
        }

        return ratingsData.map((json) {
          return Rating.fromJson(Map<String, dynamic>.from(json));
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ API List Ratings Error: $e');
      return [];
    }
  }

  /// ── Gửi đánh giá mới lên Server (Yêu cầu Token) ──
  Future<bool> createRating(int movieId, double score, String? review) async {
    try {
      final response = await _dio.post(
        '/movies/$movieId/ratings',
        data: {
          'score': score.toInt(),
          if (review != null) 'comment': review,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data['success'] == true) {
          return true;
        }
      }
      return false;
    } on DioException {
      // Đẩy nguyên lỗi DioException (chứa statusCode 403, 409) lên tầng Provider bắt thông báo
      rethrow;
    } catch (e) {
      debugPrint('❌ API Create Rating Unexpected Error: $e');
      return false;
    }
  }
}