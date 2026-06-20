import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _localeKey = 'app_locale';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('vi');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  // Tải ngôn ngữ đã lưu khi mở app
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_localeKey);
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
      notifyListeners();
    }
  }

  // Hàm gọi khi người dùng bấm chọn ngôn ngữ ở màn hình Profile
  Future<void> setLocale(Locale newLocale) async {
    if (newLocale == _locale) return;
    
    _locale = newLocale;
    notifyListeners(); // Thông báo cho app vẽ lại màn hình
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, newLocale.languageCode);
  }
}
