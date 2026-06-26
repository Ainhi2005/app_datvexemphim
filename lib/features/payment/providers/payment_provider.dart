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
  int? currentBookingId;

  Future<void> initPayment(BookingSelection userSelection) async {
    selection = userSelection;
    currentBookingId = null; // Reset booking ID cho phiên thanh toán mới
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

  Future<int?> initiatePaymentFlow() async {
    if (selection == null) return null;
    isLoading = true; errorMessage = null; notifyListeners();
    try {
      List<Map<String, dynamic>> comboItems = availableCombos.where((c) => c.quantity > 0).map((c) => {"comboId": c.id, "quantity": c.quantity}).toList();
      
      if (currentBookingId == null) {
        currentBookingId = await _repository.createBooking(showtimeId: selection!.showtimeId, seatIds: selection!.selectedSeatIds, comboItems: comboItems);
      }
      
      int paymentId = await _repository.initiatePayment(currentBookingId!, selectedMethod);
      isLoading = false; notifyListeners();
      return paymentId;
    } catch (e) {
      isLoading = false; 
      if (e is DioException && e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response!.data['message'].toString();
      } else {
        errorMessage = "Lỗi khởi tạo thanh toán. Vui lòng thử lại!"; 
      }
      notifyListeners();
      return null;
    }
  }

  Future<int?> retryPayment(int bookingId, String method) async {
    isLoading = true; errorMessage = null; notifyListeners();
    try {
      int paymentId = await _repository.initiatePayment(bookingId, method);
      isLoading = false; notifyListeners();
      return paymentId;
    } catch (e) {
      isLoading = false; 
      if (e is DioException && e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response!.data['message'].toString();
      } else {
        errorMessage = "Lỗi khởi tạo thanh toán lại."; 
      }
      notifyListeners();
      return null;
    }
  }

  Future<bool> confirmPaymentFlow(int paymentId) async {
    isLoading = true; notifyListeners();
    try {
      final confirmData = await _repository.confirmPayment(paymentId);
      confirmedOrderId = confirmData['data']['booking']['id'].toString();
      generatedQrCode = confirmData['data']['ticket']['qrCode'];
      isLoading = false; notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = "Xác nhận thanh toán thất bại.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> failPaymentFlow(int paymentId) async {
    isLoading = true; notifyListeners();
    try {
      await _repository.failPayment(paymentId);
      isLoading = false; notifyListeners();
      return true;
    } catch (e) {
      isLoading = false; notifyListeners();
      return false;
    }
  }
}