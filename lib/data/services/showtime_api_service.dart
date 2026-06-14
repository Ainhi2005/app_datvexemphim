import 'package:flutter/foundation.dart';
// lib/data/services/showtime_api_service.dart
import '../models/showtime.dart';
import '../../core/utils/dio_client.dart';

class ShowtimeApiService {
  final DioClient _dioClient = DioClient();

  Future<List<Showtime>> getShowtimesByMovieId(int movieId) async {
    try {
      final response = await _dioClient.dio.get(
        '/showtimes', 
        queryParameters: {'movieId': movieId},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> showtimesData = response.data['data'] ?? [];
        
        return showtimesData.map((json) {
          return Showtime.fromJson(Map<String, dynamic>.from(json));
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ API Showtimes Error: $e');
      return [];
    }
  }

  // ── Lấy tất cả suất chiếu (Admin) ──
  Future<List<Showtime>> getAllShowtimes() async {
    try {
      final response = await _dioClient.dio.get('/showtimes');
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> showtimesData = response.data['data'] ?? [];
        return showtimesData.map((json) {
          return Showtime.fromJson(Map<String, dynamic>.from(json));
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ API Get All Showtimes Error: $e');
      return [];
    }
  }

  // ── Tạo suất chiếu mới (POST /showtimes) ──
  Future<Map<String, dynamic>> createShowtime({
    required int movieId,
    required int roomId,
    required String startTime,
    required double basePrice,
    required double vipPrice,
    required double couplePrice,
  }) async {
    final response = await _dioClient.dio.post(
      '/showtimes',
      data: {
        'movieId': movieId,
        'roomId': roomId,
        'startTime': startTime,
        'basePrice': basePrice,
        'vipPrice': vipPrice,
        'couplePrice': couplePrice,
      },
    );
    return response.data;
  }

  // ── Hủy suất chiếu (PATCH /showtimes/:id/cancel) ──
  Future<void> deleteShowtime(int showtimeId) async {
    await _dioClient.dio.patch('/showtimes/$showtimeId/cancel');
  }
}