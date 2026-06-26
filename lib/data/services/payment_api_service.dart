import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/token_storage.dart';

class PaymentApiService {
  late final Dio _dio;

  PaymentApiService() {
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

  Future<Response> getCombos() async => await _dio.get('/combos?isActive=true');
  Future<Response> createBooking(Map<String, dynamic> data) async => await _dio.post('/bookings', data: data);
  Future<Response> initiatePayment(Map<String, dynamic> data) async => await _dio.post('/payments', data: data);
  Future<Response> confirmPayment(int paymentId) async => await _dio.post('/payments/$paymentId/confirm');
  Future<Response> failPayment(int paymentId) async => await _dio.post('/payments/$paymentId/fail');
  Future<Response> cancelBooking(int bookingId) async => await _dio.patch('/bookings/$bookingId/cancel');
}