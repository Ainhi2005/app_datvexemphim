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
      print('🔍 [RatingProvider] Đang gọi API fetchRatings cho movieId: $movieId...');
      _ratings = await _apiService.getMovieRatings(movieId);
      print('✅ [RatingProvider] Lấy data Rating thành công. Số lượng: ${_ratings.length}');
      
      // Tính toán điểm trung bình động hệ 10 từ DB đổ về
      if (_ratings.isNotEmpty) {
        double sum = _ratings.fold(0, (prev, element) => prev + element.score);
        _averageScore = sum / _ratings.length;
        print('🎯 [RatingProvider] Điểm trung bình tính được (Hệ 10): $_averageScore');
      } else {
        _averageScore = 0.0;
      }
    } catch (e, stacktrace) {
      // 🔥 LOG CHÍ MẠNG: Giúp bạn biết hàm fetch bị sập ở dòng nào
      print('❌ [RatingProvider] LỖI TRONG HÀM fetchRatings: $e');
      print('📌 [RatingProvider] Chi tiết StackTrace: $stacktrace');
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
    print('🚀 [RatingProvider] Bắt đầu submitRating cho movieId: $movieId, score: $score');

    // 1. Kiểm tra trạng thái đăng nhập phía Client
    if (token == null || token.isEmpty) {
      print('⚠️ [RatingProvider] Submit thất bại: Không tìm thấy Token người dùng.');
      return "Vui lòng đăng nhập để thực hiện đánh giá bộ phim này.";
    }

    _apiService.updateToken(token);

    try {
      final bool isSuccess = await _apiService.createRating(movieId, score, review);
      if (isSuccess) {
        print('🎉 [RatingProvider] Tạo rating thành công trên Server, đang refresh lại danh sách...');
        await fetchRatings(movieId); 
        return null; 
      }
      return "Đã xảy ra lỗi không xác định, vui lòng thử lại sau.";
    } on DioException catch (e) {
      // 🔥 LOG CHÍ MẠNG: In sạch sành sanh phản hồi lỗi từ Dio mạng gửi về
      print('❌ [RatingProvider] LỖI DIO KHI SUBMIT RATING: [Type] -> ${e.type}');
      print('❌ [RatingProvider] Status Code từ Server: ${e.response?.statusCode}');
      print('❌ [RatingProvider] Cục Data lỗi Server trả về: ${e.response?.data}');

      if (e.response != null) {
        final status = e.response!.statusCode;
        final data = e.response!.data;
        
        String serverMessage = (data is Map) ? (data['message'] ?? '') : '';
        print('💬 [RatingProvider] Thông điệp bóc tách từ BE: "$serverMessage"');

        if (status == 403) {
          return serverMessage.isNotEmpty ? serverMessage : "Bạn chỉ có thể đánh giá phim sau khi đã xem.";
        } else if (status == 409) {
          return serverMessage.isNotEmpty ? serverMessage : "Bạn đã đánh giá phim này rồi.";
        }
      }
      return "Lỗi kết nối Server (${e.type}). Vui lòng thử lại.";
    } catch (e, stacktrace) {
      print('❌ [RatingProvider] Lỗi hệ thống không xác định tại submitRating: $e');
      print('📌 StackTrace: $stacktrace');
      return "Đã xảy ra lỗi hệ thống: $e";
    }
  }

  void _errorCleanUp() {}
}