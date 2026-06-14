import 'package:flutter/foundation.dart';
import '../../core/utils/dio_client.dart';

class CinemaApiService {
  final DioClient _dioClient = DioClient();

  // 1. Lấy danh sách suất chiếu của 1 bộ phim
  Future<List<dynamic>> getShowtimesByMovie(int movieId) async {
    try {
      final response = await _dioClient.dio.get('/showtimes', queryParameters: {'movieId': movieId, 'movie_id': movieId});
      debugPrint("🔍 RAW DATA TỪ NODE.JS: ${response.data}");
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as List;
      }
    } catch (e) {
      debugPrint("Lỗi API lấy suất chiếu: $e");
    }
    return [];
  }

  // 2. Lấy sơ đồ ghế thực tế từ backend theo mã suất chiếu
  Future<List<dynamic>> getSeatsByShowtime(int showtimeId) async {
    try {
      final response = await _dioClient.dio.get('/bookings/showtimes/$showtimeId/seats');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as List;
      }
    } catch (e) {
      debugPrint("Lỗi API lấy sơ đồ ghế: $e");
    }
    return [];
  }

  // 3. Thực hiện gửi lệnh Đặt Vé lên hệ thống (Giữ ghế 10 phút)
  Future<bool> postCreateBooking(int showtimeId, List<int> seatIds) async {
    try {
      final response = await _dioClient.dio.post('/bookings', data: {
        'showtimeId': showtimeId,
        'seatIds': seatIds,
        'comboItems': [] // Gửi mảng rỗng nếu không chọn bắp nước
      });
      return response.statusCode == 201 || response.data['success'] == true;
    } catch (e) {
      debugPrint("Lỗi API đặt vé: $e");
      return false;
    }
  }

  // ==========================================
  // ── ADMIN CINEMA CRUD ENDPOINTS ──
  // ==========================================

  // Lấy danh sách rạp
  Future<List<dynamic>> getCinemas() async {
    final response = await _dioClient.dio.get('/cinemas');
    if (response.statusCode == 200) {
      return response.data['data'] as List;
    }
    return [];
  }

  // Thêm rạp
  Future<Map<String, dynamic>> createCinema(
    String name,
    String address, {
    required String city,
    String? phone,
    String? imageUrl,
  }) async {
    final response = await _dioClient.dio.post(
      '/cinemas',
      data: {
        'name': name,
        'address': address,
        'city': city,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        if (imageUrl != null && imageUrl.isNotEmpty) 'imageUrl': imageUrl,
      },
    );
    return response.data;
  }

  // Cập nhật rạp
  Future<Map<String, dynamic>> updateCinema(
    int id,
    String name,
    String address, {
    required String city,
    String? phone,
    String? imageUrl,
  }) async {
    final response = await _dioClient.dio.patch(
      '/cinemas/$id',
      data: {
        'name': name,
        'address': address,
        'city': city,
        'phone': phone,
        'imageUrl': imageUrl,
      },
    );
    return response.data;
  }

  // Xóa rạp
  Future<void> deleteCinema(int id) async {
    await _dioClient.dio.delete('/cinemas/$id');
  }

  // Lấy danh sách phòng của rạp
  Future<List<dynamic>> getRooms(int cinemaId) async {
    final response = await _dioClient.dio.get('/cinemas/$cinemaId/rooms');
    if (response.statusCode == 200) {
      return response.data['data'] as List;
    }
    return [];
  }

  // Tạo phòng (tự sinh ghế theo grid)
  Future<Map<String, dynamic>> createRoom({
    required int cinemaId,
    required String name,
    required String type,
    required int totalRows,
    required int seatsPerRow,
  }) async {
    final response = await _dioClient.dio.post(
      '/cinemas/$cinemaId/rooms',
      data: {
        'name': name,
        'type': type,
        'totalRows': totalRows,
        'seatsPerRow': seatsPerRow,
      },
    );
    return response.data;
  }

  // Cập nhật phòng
  Future<Map<String, dynamic>> updateRoom(int roomId, {
    required String name,
    required String type,
    required int totalRows,
    required int seatsPerRow,
  }) async {
    final response = await _dioClient.dio.patch(
      '/rooms/$roomId',
      data: {
        'name': name,
        'type': type,
        'totalRows': totalRows,
        'seatsPerRow': seatsPerRow,
      },
    );
    return response.data;
  }

  // Xóa phòng
  Future<void> deleteRoom(int roomId) async {
    await _dioClient.dio.delete('/rooms/$roomId');
  }

  // Sơ đồ ghế của phòng
  Future<dynamic> getRoomSeats(int roomId) async {
    final response = await _dioClient.dio.get('/rooms/$roomId/seats');
    if (response.statusCode == 200) {
      return response.data['data'];
    }
    return null;
  }

  // Cập nhật ghế (type, isActive)
  Future<Map<String, dynamic>> updateSeat(int seatId, {
    required String type,
    required bool isActive,
  }) async {
    final response = await _dioClient.dio.patch(
      '/seats/$seatId',
      data: {
        'type': type,
        'isActive': isActive,
      },
    );
    return response.data;
  }

  // ==========================================
  // ── ADMIN COMBO CRUD ENDPOINTS ──
  // ==========================================

  // Lấy danh sách Combo
  Future<List<dynamic>> getCombos() async {
    final response = await _dioClient.dio.get('/combos');
    if (response.statusCode == 200) {
      if (response.data is Map && response.data['success'] == true) {
        return response.data['data'] as List;
      } else if (response.data is List) {
        return response.data as List;
      }
    }
    return [];
  }

  // Tạo Combo mới
  Future<Map<String, dynamic>> createCombo({
    required String name,
    required double price,
    String? description,
    String? imageUrl,
  }) async {
    final response = await _dioClient.dio.post(
      '/combos',
      data: {
        'name': name,
        'price': price,
        if (description != null) 'description': description,
        if (imageUrl != null) 'imageUrl': imageUrl,
      },
    );
    return response.data;
  }

  // Cập nhật Combo
  Future<Map<String, dynamic>> updateCombo(
    int id, {
    String? name,
    double? price,
    String? description,
    String? imageUrl,
    bool? isActive,
  }) async {
    final response = await _dioClient.dio.patch(
      '/combos/$id',
      data: {
        if (name != null) 'name': name,
        if (price != null) 'price': price,
        if (description != null) 'description': description,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (isActive != null) 'isActive': isActive,
      },
    );
    return response.data;
  }

  // Xóa Combo
  Future<void> deleteCombo(int id) async {
    await _dioClient.dio.delete('/combos/$id');
  }
}