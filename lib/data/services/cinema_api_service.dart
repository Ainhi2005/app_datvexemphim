import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';

class CinemaApiService {
  late final Dio _dio;

  CinemaApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
  }

  // 1. Lấy danh sách suất chiếu của 1 bộ phim
  Future<List<dynamic>> getShowtimesByMovie(int movieId) async {
    try {
      final response = await _dio.get('/showtimes', queryParameters: {'movieId': movieId, 'movie_id': movieId});

    // 💡 THÊM DÒNG NÀY ĐỂ SOI DỮ LIỆU THỰC TẾ TRÊN TERMINAL:
      print("🔍 RAW DATA TỪ NODE.JS: ${response.data}");
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as List;
      }
    } catch (e) {
      print("Lỗi API lấy suất chiếu: $e");
    }
    return [];
  }

  // 2. Lấy sơ đồ ghế thực tế từ backend theo mã suất chiếu
  Future<List<dynamic>> getSeatsByShowtime(int showtimeId) async {
    try {
      final response = await _dio.get('/bookings/showtimes/$showtimeId/seats');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as List;
      }
    } catch (e) {
      print("Lỗi API lấy sơ đồ ghế: $e");
    }
    return [];
  }

  // 3. Thực hiện gửi lệnh Đặt Vé lên hệ thống (Giữ ghế 10 phút)
  Future<bool> postCreateBooking(int showtimeId, List<int> seatIds) async {
    try {
      final response = await _dio.post('/bookings', data: {
        'showtimeId': showtimeId,
        'seatIds': seatIds,
        'comboItems': [] // Gửi mảng rỗng nếu không chọn bắp nước
      });
      return response.statusCode == 201 || response.data['success'] == true;
    } catch (e) {
      print("Lỗi API đặt vé: $e");
      return false;
    }
  }
}