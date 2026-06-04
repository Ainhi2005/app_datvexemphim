// lib/data/services/showtime_api_service.dart
import 'package:dio/dio.dart';
import '../models/showtime.dart';
import '../../core/constants/api_constants.dart';

class ShowtimeApiService {
  late final Dio _dio;

  ShowtimeApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  Future<List<Showtime>> getShowtimesByMovieId(int movieId) async {
    try {
      final response = await _dio.get(
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
      print('❌ API Showtimes Error: $e');
      return [];
    }
  }
}