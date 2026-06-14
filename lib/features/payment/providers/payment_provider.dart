import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../data/models/combo_model.dart';
import '../../../data/models/booking_selection.dart';
import '../../../data/repositories/payment_repository.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentRepository _repository = PaymentRepository();

  BookingSelection? selection;
  List<ComboModel> availableCombos = [];
  String selectedMethod = "MOCK";
  bool isLoading = false;
  String? errorMessage;
  String? confirmedOrderId;
  String? generatedQrCode;
  DateTime? showTimeDate;

  Future<void> initPayment(BookingSelection userSelection) async {
    selection = userSelection;
    isLoading = true;
    showTimeDate = userSelection.showtimeDate ?? DateTime.now();
    notifyListeners();
    try { availableCombos = await _repository.getCombos(); }
    catch (e) { availableCombos = []; }
    finally { isLoading = false; notifyListeners(); }
  }

  void updateComboQuantity(int index, bool isAdd) {
    if (isAdd) {
      availableCombos[index].quantity++;
    } else if (availableCombos[index].quantity > 0) {
      availableCombos[index].quantity--;
    }
    notifyListeners();
  }

  void selectMethod(String method) { selectedMethod = method; notifyListeners(); }

  double get totalPrice {
    if (selection == null) return 0;
    double comboTotal = availableCombos.fold(0, (sum, item) => sum + (item.price * item.quantity));
    return (selection!.seatPrice * selection!.selectedSeatIds.length) + comboTotal;
  }

  Future<bool> processCheckout() async {
    if (selection == null) return false;
    isLoading = true; errorMessage = null; notifyListeners();
    try {
      List<Map<String, dynamic>> comboItems = availableCombos.where((c) => c.quantity > 0).map((c) => {"comboId": c.id, "quantity": c.quantity}).toList();
      int bookingId = await _repository.createBooking(showtimeId: selection!.showtimeId, seatIds: selection!.selectedSeatIds, comboItems: comboItems);
      int paymentId = await _repository.initiatePayment(bookingId, selectedMethod);
      final confirmData = await _repository.confirmPayment(paymentId);
      confirmedOrderId = confirmData['data']['booking']['id'].toString();
      generatedQrCode = confirmData['data']['ticket']['qrCode'];
      isLoading = false; notifyListeners();
      return true;
    } catch (e) {
      isLoading = false; 
      if (e is DioException && e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response!.data['message'].toString();
      } else {
        errorMessage = "Lỗi thanh toán. Vui lòng thử lại!"; 
      }
      notifyListeners();
      return false;
    }
  }
}