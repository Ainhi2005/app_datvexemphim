import 'package:flutter/material.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../../core/utils/token_storage.dart'; // Import thêm để đọc token khi khởi tạo
import '../../../core/utils/error_handler.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  final TokenStorage _tokenStorage = TokenStorage(); // Thêm instance để check auto-login
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // 💡 BIẾN QUAN TRỌNG: Lưu accessToken động trên RAM để các màn hình khác lấy dùng
  String? _token;
  String? get token => _token;

  // Kiểm tra trạng thái xem người dùng đã đăng nhập chưa
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // 💡 HÀM BỔ SUNG: Tự động lấy token từ ổ cứng khi app vừa bật (Chống mất trạng thái đăng nhập)
  Future<void> tryAutoLogin() async {
    final savedToken = await _tokenStorage.getAccessToken();
    if (savedToken != null && savedToken.isNotEmpty) {
      _token = savedToken;
      notifyListeners();
    }
  }

  Future<bool> loginWithEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      // Hứng đối tượng AuthResponseModel trả ra từ Repository
      final authResponse = await _repository.loginWithEmail(email, password);
      
      // 💡 GĂM TOKEN VÀO RAM
      _token = authResponse.accessToken; 
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = ErrorHandler.handle(e).message;
      _setLoading(false);
      return false;
    }
  }
  
  Future<bool> register(String email, String username, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final authResponse = await _repository.register(email, username, password);
      _token = authResponse.accessToken; // 💡 GĂM TOKEN
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = ErrorHandler.handle(e).message;
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _repository.logout();
      _token = null; // 💡 Xóa sạch vết token trên RAM khi đăng xuất
    } catch (e) {
      debugPrint('Lỗi đăng xuất: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }
}
