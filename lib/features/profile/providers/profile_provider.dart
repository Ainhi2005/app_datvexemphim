import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../core/utils/dio_client.dart';
import '../../../core/utils/error_handler.dart';

class ProfileProvider extends ChangeNotifier {
  final UserRepository _repository = UserRepository();
  final DioClient _dioClient = DioClient();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _repository.getProfile();
    } catch (e) {
      _error = ErrorHandler.handle(e).message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? dob,
    String? avatarUrl,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> data = {};
      if (name != null && name.isNotEmpty) data['name'] = name;
      if (phone != null && phone.isNotEmpty) data['phone'] = phone;
      if (dob != null && dob.isNotEmpty) data['dateOfBirth'] = dob;
      if (avatarUrl != null && avatarUrl.isNotEmpty)
        data['avatarUrl'] = avatarUrl;

      _user = await _repository.updateProfile(data);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = ErrorHandler.handle(e).message;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.changePassword(currentPassword, newPassword);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = ErrorHandler.handle(e).message;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<String?> uploadAvatar(String filePath) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Thiết lập MultipartFile gửi file vật lý từ ổ đĩa máy điện thoại
      String fileName = filePath.split('/').last;
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(filePath, filename: fileName), 
      });

      // Gọi API đến router upload của Node.js
      final response = await _dioClient.dio.post(
        '/upload/image',
        data: formData,
      );

      _isLoading = false;
      notifyListeners();

      // Bóc tách đúng cấu trúc JSON phản hồi từ UploadController.js { success: true, data: { url: ... } }
      if (response.statusCode == 200 && response.data != null) {
        return response.data['data']['url']; // Trả về link ảnh HTTPS hoàn chỉnh
      }
      return null;
    } catch (e) {
      // Bắt lỗi động nếu file quá lớn, sai định dạng hoặc mất mạng
      _error = ErrorHandler.handle(e).message;
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
