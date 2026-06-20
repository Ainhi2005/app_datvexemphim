import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RememberMeStorage {
  static const String _keySavedAccounts = 'saved_accounts';

  // 1. Lấy danh sách tất cả tài khoản đã lưu
  static Future<List<Map<String, String>>> getSavedAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accountsString = prefs.getString(_keySavedAccounts);
    if (accountsString == null || accountsString.isEmpty) return [];
    
    // Parse JSON string thành mảng
    final List<dynamic> decoded = json.decode(accountsString);
    return decoded.map((e) => Map<String, String>.from(e)).toList();
  }

  // 2. Lưu hoặc cập nhật tài khoản (khi ấn Đăng nhập & có tích "Nhớ mật khẩu")
  static Future<void> saveAccount(String email, String password) async {
    final accounts = await getSavedAccounts();
    
    // Xóa tài khoản này nếu đã tồn tại trong list (để tránh trùng lặp)
    accounts.removeWhere((acc) => acc['email'] == email);
    
    // Chèn tài khoản mới đăng nhập lên ĐẦU danh sách
    accounts.insert(0, {'email': email, 'password': password});
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySavedAccounts, json.encode(accounts));
  }

  // 3. Xóa một tài khoản (khi người dùng bỏ tích "Nhớ mật khẩu" hoặc bấm nút xóa tài khoản trong list)
  static Future<void> removeAccount(String email) async {
    final accounts = await getSavedAccounts();
    accounts.removeWhere((acc) => acc['email'] == email);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySavedAccounts, json.encode(accounts));
  }
}
