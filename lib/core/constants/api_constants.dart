class ApiConstants {
  // Cho Android emulator
  /// Lớp chứa các hằng số liên quan đến API.
  /// Dùng chung cho tất cả các service gọi mạng.
  /// Có thể mở rộng thêm các endpoint khác như /users, /auth,...
  static const String baseUrl = 'http://10.0.2.2:3000';
  static const String movies = '/movies';
}