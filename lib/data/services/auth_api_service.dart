import 'package:flutter/foundation.dart';
import '../../core/utils/dio_client.dart';

class AuthApiService {
  final _dioClient = DioClient();

  Future<Map<String, dynamic>> loginWithEmail(
    String email,
    String password,
  ) async {
    final response = await _dioClient.dio.post(
      '/auth/signIn',
      data: {'email': email, 'password': password},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> register(
    String email,
    String username,
    String password,
  ) async {
    final response = await _dioClient.dio.post(
      '/auth/signUp',
      data: {'email': email, 'name': username, 'password': password},
    );
    return response.data;
  }

  Future<void> signOut() async {
    try {
      await _dioClient.dio.post('/auth/signOut');
    } catch (e) {
      // C� th? b? qua l?i ? d�y v� d� server c� l?i, ta v?n ph?i cho user dang xu?t ? app
      debugPrint('L?i g?i API signOut: $e');
    }
  }

  // Fake responses for social logins
  Future<Map<String, dynamic>> loginWithFacebook() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'accessToken': 'mock_token_facebook',
      'refreshToken': 'mock_refresh_facebook',
    };
  }

  Future<Map<String, dynamic>> loginWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'accessToken': 'mock_token_google',
      'refreshToken': 'mock_refresh_google',
    };
  }
}
