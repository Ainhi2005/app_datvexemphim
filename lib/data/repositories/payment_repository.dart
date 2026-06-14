import '../models/combo_model.dart';
import '../services/payment_api_service.dart';

class PaymentRepository {
  final PaymentApiService _apiService = PaymentApiService();

  Future<List<ComboModel>> getCombos() async {
    final response = await _apiService.getCombos();
    return (response.data['data'] as List).map((json) => ComboModel.fromJson(json)).toList();
  }

  Future<int> createBooking({required int showtimeId, required List<int> seatIds, required List<Map<String, dynamic>> comboItems}) async {
    final response = await _apiService.createBooking({"showtimeId": showtimeId, "seatIds": seatIds, "comboItems": comboItems});
    return response.data['data']['id'];
  }

  Future<int> initiatePayment(int bookingId, String provider) async {
    final response = await _apiService.initiatePayment({"bookingId": bookingId, "provider": provider});
    return response.data['data']['id'];
  }

  Future<Map<String, dynamic>> confirmPayment(int paymentId) async {
    final response = await _apiService.confirmPayment(paymentId);
    return response.data;
  }
}