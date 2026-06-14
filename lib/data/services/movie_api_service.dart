import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/dio_client.dart';

class MovieApiService {
  final _dioClient = DioClient();

  Future<Map<String, dynamic>> getMovieRatingStats(int movieId) async {
    try {
      final response = await _dioClient.dio.get('${ApiConstants.movies}/$movieId/ratings');
      if (response.statusCode == 200 && response.data['success'] == true) {
        final meta = response.data['meta'];
        return {
          'averageScore': (meta['averageScore'] ?? 0.0).toDouble(),
          'totalRatings': meta['totalRatings'] ?? 0,
        };
      }
      return {'averageScore': 0.0, 'totalRatings': 0};
    } catch (e) {
      debugPrint('❌ API Ratings Error: $e');
      return {'averageScore': 0.0, 'totalRatings': 0};
    }
  }

  Future<List<Movie>> getMoviesByStatus(String? status) async {
    try {
      final Map<String, dynamic> queryParams = status != null ? {'status': status} : {};
      final response = await _dioClient.dio.get(
        ApiConstants.movies,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final List<dynamic> movieList = [];

        if (responseData is List) {
          movieList.addAll(responseData);
        } else if (responseData is Map) {
          if (responseData['success'] == true || responseData.containsKey('data')) {
            final moviesData = responseData['data'];
            if (moviesData is List) {
              movieList.addAll(moviesData);
            } else if (moviesData is Map && moviesData.containsKey('data')) {
              movieList.addAll(moviesData['data'] as List);
            }
          }
        }

        return movieList.map((json) {
          final Map<String, dynamic> movieMap = {};
          if (json is Map) {
            json.forEach((key, value) {
              movieMap[key.toString()] = value;
            });
          }
          return Movie.fromJson(movieMap);
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('API Error in getMoviesByStatus: $e');
      rethrow;
    }
  }

  Future<List<Movie>> getNowShowingMovies() async {
    return await getMoviesByStatus('now_showing');
  }

  Future<List<Movie>> getComingSoonMovies() async {
    return await getMoviesByStatus('coming_soon');
  }

  Future<List<Movie>> getAllMovies() async {
    return await getMoviesByStatus(null);
  }

  // =========================================================================
  // 💡 VIẾT THÊM: Hàm gọi API lấy danh sách Suất chiếu (Showtimes) theo ID Phim
  // =========================================================================
  Future<dynamic> getShowtimes(int movieId) async {
    try {
      // Thực hiện bắn lệnh GET request lên endpoint: /showtimes?movieId=3
      final response = await _dioClient.dio.get(
        '/showtimes',
        queryParameters: {
          'movieId': movieId, // Truyền tham số lọc theo đúng cấu trúc Postman
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        // Trả về thẳng cục dữ liệu Map/Json thô để tầng Repository bóc tách đa tầng
        return response.data;
      }
      
      return null;
    } catch (e) {
      debugPrint('❌ Lỗi kết nối API tại hàm getShowtimes: $e');
      // Ném lỗi hoặc trả về null để luồng Repository xử lý fallback mảng rỗng
      return null; 
    }
  }
  /// Lấy danh sách tất cả rạp phim
  Future<dynamic> getCinemasList() async {
    try {
      final response = await _dioClient.dio.get('/cinemas'); 
      return response.data;
    } catch (e) {
      debugPrint('❌ Lỗi getCinemasList: $e');
      rethrow;
    }
  }

  /// 💡 THÊM HÀM NÀY: Khớp chính xác với ảnh Postman mới của bạn
  Future<dynamic> getRoomsByCinema(int cinemaId) async {
    try {
      final response = await _dioClient.dio.get('/cinemas/$cinemaId/rooms');
      return response.data;
    } catch (e) {
      debugPrint('❌ Lỗi getRoomsByCinema cho rạp ID $cinemaId: $e');
      rethrow;
    }
  }

  /// ── Thêm Phim Mới (POST) ──
  Future<Map<String, dynamic>> createMovie({
    required String title,
    required int duration,
    required String description,
    required String posterUrl,
    required List<String> genres,
    required List<String> directors,
    required String releaseDate,
    required String endDate,
    required String ageRating,
    required String language,
  }) async {
    final response = await _dioClient.dio.post(
      '/movies',
      data: {
        'title': title,
        'duration': duration,
        'description': description,
        'posterUrl': posterUrl,
        'genres': genres,
        'directors': directors,
        'releaseDate': releaseDate,
        'endDate': endDate,
        'ageRating': ageRating,
        'language': language,
      },
    );
    return response.data;
  }

  /// ── Cập Nhật Phim (PATCH) ──
  Future<Map<String, dynamic>> updateMovie(
    int movieId, {
    required String title,
    required int duration,
    required String description,
    required String posterUrl,
    required List<String> genres,
    required List<String> directors,
    required String releaseDate,
    required String endDate,
    required String ageRating,
    required String language,
  }) async {
    final response = await _dioClient.dio.patch(
      '/movies/$movieId',
      data: {
        'title': title,
        'duration': duration,
        'description': description,
        'posterUrl': posterUrl,
        'genres': genres,
        'directors': directors,
        'releaseDate': releaseDate,
        'endDate': endDate,
        'ageRating': ageRating,
        'language': language,
      },
    );
    return response.data;
  }

  /// ── Xóa Phim (DELETE) ──
  Future<void> deleteMovie(int movieId) async {
    await _dioClient.dio.delete('/movies/$movieId');
  }
}