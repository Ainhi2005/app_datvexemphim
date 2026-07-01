// lib/data/models/auth_response_model.dart
class AuthResponseModel {
  final String accessToken;
  final String refreshToken;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // 1. Tìm block chứa dữ liệu thật (bọc trong 'data' của cấu trúc Backend chuẩn)
    final dynamic dataBlock = json['data'] ?? json;

    String accToken = '';
    String refToken = '';

    if (dataBlock is Map<String, dynamic>) {
      
      accToken = dataBlock['token'] ?? '';
      refToken = dataBlock['refreshToken'] ?? '';
    }

    return AuthResponseModel(
      accessToken: accToken,
      refreshToken: refToken,
    );
  }
}