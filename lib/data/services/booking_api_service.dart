import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';

class BookingApiService {
  // Đảm bảo baseUrl trỏ chuẩn về: 'http://192.168.42.29:3000'
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  // 💡 CHUẨN HÓA THEO ENDPOINT THẬT: Đổi từ showtimeId sang roomId và dùng phương thức GET
  Future<Response> getSeatsByRoom(int roomId) async {
    try {
      print("🚀 [API Ghế] Đang gọi GET tới: ${ApiConstants.baseUrl}/rooms/$roomId/seats");
      
      // Khớp 100% với endpoint: GET /rooms/:roomId/seats
      // (Nhớ thêm /api ở trước nếu tất cả endpoint của BE đều nằm sau router /api)
      final response = await _dio.get('/rooms/$roomId/seats');
      
      // Nếu Backend không dùng tiền tố /api thì dùng dòng dưới:
      // final response = await _dio.get('/rooms/$roomId/seats');
      
      return response;
    } catch (e) {
      print("❌ Lỗi gọi API lấy sơ đồ ghế từ Room: $e");
      rethrow;
    }
  }

  // Gửi yêu cầu đặt vé (Khớp với endpoint POST /bookings nếu có)
  Future<Response> createBooking(Map<String, dynamic> bookingData) async {
    try {
      return await _dio.post('/bookings', data: bookingData);
    } catch (e) {
      print("❌ Lỗi API đặt vé: $e");
      rethrow;
    }
  }
}