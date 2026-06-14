import 'package:dio/dio.dart';
import '../../core/utils/dio_client.dart';

class UserApiService {
  final _dioClient = DioClient();

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _dioClient.dio.get('/users/me');
    return response.data;
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _dioClient.dio.patch('/users/me', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final response = await _dioClient.dio.patch(
      '/users/me/password',
      data: {'oldPassword': oldPassword, 'newPassword': newPassword},
    );
    return response.data;
  }

  // Hàm upload ảnh lên cloudinary qua backend của bạn
  Future<Map<String, dynamic>> uploadImage(String filePath) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath, filename: 'avatar.png'),
    });
    final response = await _dioClient.dio.post('/upload/image', data: formData);
    return response.data;
  }

  // ── Lấy danh sách tất cả người dùng (Admin) ──
  Future<Map<String, dynamic>> getAllUsers() async {
    final response = await _dioClient.dio.get('/users');
    return response.data;
  }

  // ── Cập nhật vai trò người dùng (Admin) ──
  Future<Map<String, dynamic>> updateUserRole(int userId, String role) async {
    final response = await _dioClient.dio.patch(
      '/users/$userId/role',
      data: {'role': role},
    );
    return response.data;
  }
}
