import '../../../core/utils/dio_client.dart';
import '../../../core/utils/token_storage.dart';

class AuthService {
  final _dioClient = DioClient();
  final _tokenStorage = TokenStorage();

  static void clearTempData() {
    // Clear temporary registration data
  }

  Future<String> loginWithEmail(String email, String password) async {
    try {
      final response = await _dioClient.dio.post('/auth/signIn', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final accessToken = data['accessToken'] ?? 'mock_access_token';
        final refreshToken = data['refreshToken'] ?? 'mock_refresh_token';

        await _tokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        return accessToken;
      }
      throw Exception('Login failed');
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  Future<String> register(String email, String username, String password, String confirmPassword) async {
    try {
      final response = await _dioClient.dio.post('/auth/signUp', data: {
        'email': email,
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final accessToken = data['accessToken'] ?? 'mock_access_token_reg';
        final refreshToken = data['refreshToken'] ?? 'mock_refresh_token_reg';

        await _tokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        return accessToken;
      }
      throw Exception('Registration failed');
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  Future<void> logout() async {
    try {
      // Optional: notify backend about logout
      // await _dioClient.dio.post('/auth/logout');
    } finally {
      await _tokenStorage.clearTokens();
    }
  }
}
