// lib/core/utils/error_handler.dart
import 'package:dio/dio.dart';
import '../errors/app_exception.dart';

class ErrorHandler {
  static AppException handle(dynamic error) {
    if (error is DioException) {
      try {
        // 1. Kiểm tra xem Backend có trả về phản hồi kèm JSON lỗi không
        if (error.response != null && error.response?.data != null) {
          final data = error.response?.data;
          
          // Bóc tách trường 'message' động mà Backend gửi về
          if (data is Map<String, dynamic> && data.containsKey('message')) {
            return AppException(
              data['message'],
              statusCode: error.response?.statusCode,
            );
          }
        }

        // 2. Nếu lỗi kết nối mạng thông thường (Hết hạn hoặc mất kết nối)
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            return AppException("Hết thời gian kết nối đến máy chủ. Vui lòng thử lại!");
          case DioExceptionType.connectionError:
            return AppException("Không có kết nối mạng. Vui lòng kiểm tra wifi/4G!");
          default:
            return AppException("Đã xảy ra lỗi kết nối máy chủ (${error.response?.statusCode ?? 'Mất mạng'}).");
        }
      } catch (_) {
        return AppException("Đã xảy ra lỗi hệ thống không xác định.");
      }
    }
    
    // Nếu là các lỗi logic khác của hệ thống
    return AppException(error.toString());
  }
}