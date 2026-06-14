// lib/presentation/movie/providers/rating_provider.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../data/models/rating.dart';
import '../../../data/services/rating_api_service.dart';

class RatingProvider extends ChangeNotifier {
  final RatingApiService _apiService = RatingApiService();

  List<Rating> _ratings = [];
  bool _isLoading = false;
  double _averageScore = 0.0;

  List<Rating> get ratings => _ratings;
  bool get isLoading => _isLoading;
  double get averageScore => _averageScore;
  int get totalRatings => _ratings.length;

  /// ── Gọi nạp danh sách và tính điểm trung bình ──
  Future<void> fetchRatings(int movieId) async {
    _isLoading = true;
    _errorCleanUp();
    Future.microtask(() => notifyListeners());

    try {
      debugPrint('[RatingProvider] Fetching ratings for movieId: $movieId');
      _ratings = await _apiService.getMovieRatings(movieId);
      debugPrint('[RatingProvider] Fetched ${_ratings.length} ratings');
      
      // Tính toán điểm trung bình động hệ 10 từ DB đổ về
      if (_ratings.isNotEmpty) {
        double sum = _ratings.fold(0, (prev, element) => prev + element.score);
        _averageScore = sum / _ratings.length;
        debugPrint('[RatingProvider] Average score: $_averageScore');
      } else {
        _averageScore = 0.0;
      }
    } catch (e) {
      // 🔥 LOG CHÍ MẠNG: Giúp bạn biết hàm fetch bị sập ở dòng nào
      debugPrint('[RatingProvider] fetchRatings error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ── Gửi dữ liệu và bóc tách mã lỗi nghiệp vụ của Backend ──
  Future<String?> submitRating({
    required int movieId,
    required double score,
    String? review,
    String? token,
  }) async {
    debugPrint('[RatingProvider] submitRating movieId: $movieId, score: $score');

    // 1. Kiểm tra trạng thái đăng nhập phía Client
    if (token == null || token.isEmpty) {
      debugPrint('[RatingProvider] Submit failed: no token');
      return "Vui lòng đăng nhập để thực hiện đánh giá bộ phim này.";
    }

    _apiService.updateToken(token);

    try {
      final bool isSuccess = await _apiService.createRating(movieId, score, review);
      if (isSuccess) {
        debugPrint('[RatingProvider] Rating created, refreshing list...');
        await fetchRatings(movieId); 
        return null; 
      }
      return "Đã xảy ra lỗi không xác định, vui lòng thử lại sau.";
    } on DioException catch (e) {
      // 🔥 LOG CHÍ MẠNG: In sạch sành sanh phản hồi lỗi từ Dio mạng gửi về
      debugPrint('[RatingProvider] DioException: type=${e.type} status=${e.response?.statusCode} data=${e.response?.data}');

      if (e.response != null) {
        final status = e.response!.statusCode;
        final data = e.response!.data;
        
        String serverMessage = (data is Map) ? (data['message'] ?? '') : '';
        debugPrint('[RatingProvider] Server message: "$serverMessage"');

        if (status == 403) {
          return serverMessage.isNotEmpty ? serverMessage : "Bạn chỉ có thể đánh giá phim sau khi đã xem.";
        } else if (status == 409) {
          return serverMessage.isNotEmpty ? serverMessage : "Bạn đã đánh giá phim này rồi.";
        } else {
          return serverMessage.isNotEmpty ? serverMessage : "Lỗi $status từ máy chủ. Vui lòng thử lại.";
        }
      }
      return "Lỗi kết nối (${e.type}). Vui lòng thử lại.";
    } catch (e) {
      debugPrint('[RatingProvider] Unexpected error at submitRating: $e');
      return "Đã xảy ra lỗi hệ thống: $e";
    }
  }

  void _errorCleanUp() {}
}