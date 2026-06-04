// lib/data/repositories/movie_repository.dart

import '../models/movie.dart';
import '../services/movie_api_service.dart';
import '../models/showtime.dart';

class MovieRepository {
  final MovieApiService _apiService = MovieApiService();

  Future<List<Movie>> getNowPlaying() async {
    return await _apiService.getNowShowingMovies();
  }

  Future<List<Movie>> getComingSoon() async {
    return await _apiService.getComingSoonMovies();
  }

  // Thêm hàm lấy tất cả phim (dùng cho news)
  Future<List<Movie>> getAllMovies() async {
    return await _apiService.getAllMovies();
  }

// XÓA hàm getNews() - không dùng nữa

  // =========================================================================
  // KHÔI PHỤC: Hàm gọi đơn thô gộp Map sạch để giữ nguyên cấu trúc lồng tầng
  // =========================================================================
  Future<List<Showtime>> getShowtimesByMovieId(int movieId) async {
    try {
      final response = await _apiService.getShowtimes(movieId); 
      
      List<dynamic> rawList = [];

      if (response is List) {
        rawList = response;
      } else if (response is Map) {
        final dynamic dataBlock = response['data'];
        if (dataBlock is List) {
          rawList = dataBlock;
        } else if (dataBlock is Map && dataBlock['showtimes'] is List) {
          rawList = dataBlock['showtimes'];
        } else if (response['showtimes'] is List) {
          rawList = response['showtimes'];
        }
      }

      // Trả về luồng ép kiểu và map trực tiếp sang Model
      return rawList.map((item) {
        final Map<String, dynamic> cleanJson = Map<String, dynamic>.from(item as Map);
        return Showtime.fromJson(cleanJson);
      }).where((st) => st.status != 'CANCELLED').toList();
          
    } catch (e) {
      print('❌ Lỗi getShowtimesByMovieId trong MovieRepository: $e');
      return []; 
    }
  }
  // Hàm xây dựng bộ bản đồ tra cứu phòng chiếu toàn cục
  Future<Map<int, Map<String, String>>> buildGlobalRoomsLookupMap() async {
    Map<int, Map<String, String>> lookupMap = {};
    try {
      // 1. Lấy tất cả rạp
      final cinemaResponse = await _apiService.getCinemasList();
      List<dynamic> cinemas = cinemaResponse is Map ? (cinemaResponse['data'] ?? []) : [];

      // 2. Chạy vòng lặp (tuần tự hoặc song song ngắn) lấy phòng của từng rạp
      for (var cinema in cinemas) {
        final int cinemaId = cinema['id'] ?? 0;
        final String cinemaName = cinema['name'] ?? 'Rạp MBooking';

        final roomResponse = await _apiService.getRoomsByCinema(cinemaId);
        List<dynamic> rooms = roomResponse is Map ? (roomResponse['data'] ?? []) : [];

        // Nạp các phòng chiếu của rạp này vào bản đồ tra cứu chung
        for (var room in rooms) {
          final int roomId = room['id'] ?? 0;
          final String roomName = room['name'] ?? 'Phòng chiếu';
          
          lookupMap[roomId] = {
            'cinemaName': cinemaName,
            'roomName': roomName,
          };
        }
      }
      return lookupMap;
    } catch (e) {
      print('❌ Lỗi xây dựng Lookup Map tại Repository: $e');
      return lookupMap;
    }
  }
}