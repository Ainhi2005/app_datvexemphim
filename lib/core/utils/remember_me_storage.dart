import 'package:shared_preferences/shared_preferences.dart';

class RememberMeStorage {
  static const String _keyRememberMe = 'remember_me';
  static const String _keyEmail = 'remember_email';
  static const String _keyPassword = 'remember_password';

  // Lưu thông tin đăng nhập khi người dùng tích chọn "Nhớ mật khẩu"
  static Future<void> saveCredentials({
    required bool rememberMe,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setBool(_keyRememberMe, true);
      await prefs.setString(_keyEmail, email);
      await prefs.setString(_keyPassword, password);
    } else {
      // Nếu không tích chọn nữa thì xóa sạch thông tin cũ
      await prefs.remove(_keyRememberMe);
      await prefs.remove(_keyEmail);
      await prefs.remove(_keyPassword);
    }
  }

  // Đọc trạng thái nhớ mật khẩu
  static Future<bool> isRemembered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberMe) ?? false;
  }

  // Lấy email đã lưu
  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  // Lấy mật khẩu đã lưu
  static Future<String?> getSavedPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPassword);
  }

  // Xóa sạch thông tin khi người dùng Logout hoàn toàn
  static Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRememberMe);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
  }
}
