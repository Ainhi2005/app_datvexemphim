import 'package:dio/dio.dart';
import '../models/movie.dart';
import '../../core/constants/api_constants.dart';

class MovieApiService {
  late final Dio _dio;

  MovieApiService() {
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

  Future<Map<String, dynamic>> getMovieRatingStats(int movieId) async {
    try {
      final response = await _dio.get('${ApiConstants.movies}/$movieId/ratings');
      if (response.statusCode == 200 && response.data['success'] == true) {
        final meta = response.data['meta'];
        return {
          'averageScore': (meta['averageScore'] ?? 0.0).toDouble(),
          'totalRatings': meta['totalRatings'] ?? 0,
        };
      }
      return {'averageScore': 0.0, 'totalRatings': 0};
    } catch (e) {
      print('❌ API Ratings Error: $e');
      return {'averageScore': 0.0, 'totalRatings': 0};
    }
  }

  Future<List<Movie>> getMoviesByStatus(String? status) async {
    try {
      final Map<String, dynamic> queryParams = status != null ? {'status': status} : {};
      final response = await _dio.get(
        ApiConstants.movies,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        // Cách 1: Ép kiểu trực tiếp không cần as
        final responseData = response.data as Map;

        if (responseData['success'] == true) {
          final moviesData = responseData['data'];
          final List<dynamic> movieList = [];

          if (moviesData is List) {
            movieList.addAll(moviesData);
          } else if (moviesData is Map && moviesData.containsKey('data')) {
            movieList.addAll(moviesData['data'] as List);
          }

          return movieList.map((json) {
            // Ép kiểu json sang Map<String, dynamic>
            final Map<String, dynamic> movieMap = {};
            (json as Map).forEach((key, value) {
              movieMap[key.toString()] = value;
            });
            return Movie.fromJson(movieMap);
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print('API Error: $e');
      return [];
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
      final response = await _dio.get(
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
      print('❌ Lỗi kết nối API tại hàm getShowtimes: $e');
      // Ném lỗi hoặc trả về null để luồng Repository xử lý fallback mảng rỗng
      return null; 
    }
  }
  /// Lấy danh sách tất cả rạp phim
  Future<dynamic> getCinemasList() async {
    try {
      final response = await _dio.get('/cinemas'); 
      return response.data;
    } catch (e) {
      print('❌ Lỗi getCinemasList: $e');
      rethrow;
    }
  }

  /// 💡 THÊM HÀM NÀY: Khớp chính xác với ảnh Postman mới của bạn
  Future<dynamic> getRoomsByCinema(int cinemaId) async {
    try {
      final response = await _dio.get('/cinemas/$cinemaId/rooms');
      return response.data;
    } catch (e) {
      print('❌ Lỗi getRoomsByCinema cho rạp ID $cinemaId: $e');
      rethrow;
    }
  }
}