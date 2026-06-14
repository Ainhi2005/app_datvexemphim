import 'package:flutter/foundation.dart';
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
  Future<List<Movie>> getAllMovies() async {
    return await _apiService.getAllMovies();
  }
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

      return rawList.map((item) {
        final Map<String, dynamic> cleanJson = Map<String, dynamic>.from(item as Map);
        return Showtime.fromJson(cleanJson);
      }).where((st) => st.status != 'CANCELLED').toList();
          
    } catch (e) {
      debugPrint('? L?i getShowtimesByMovieId trong MovieRepository: $e');
      return []; 
    }
  }
  // H�m x�y d?ng b? b?n d? tra c?u ph�ng chi?u to�n c?c
  Future<Map<int, Map<String, String>>> buildGlobalRoomsLookupMap() async {
    Map<int, Map<String, String>> lookupMap = {};
    try {
      // 1. L?y t?t c? r?p
      final cinemaResponse = await _apiService.getCinemasList();
      List<dynamic> cinemas = cinemaResponse is Map ? (cinemaResponse['data'] ?? []) : [];

      // 2. Ch?y v�ng l?p (tu?n t? ho?c song song ng?n) l?y ph�ng c?a t?ng r?p
      for (var cinema in cinemas) {
        final int cinemaId = cinema['id'] ?? 0;
        final String cinemaName = cinema['name'] ?? 'R?p MBooking';

        final roomResponse = await _apiService.getRoomsByCinema(cinemaId);
        List<dynamic> rooms = roomResponse is Map ? (roomResponse['data'] ?? []) : [];

        // N?p c�c ph�ng chi?u c?a r?p n�y v�o b?n d? tra c?u chung
        for (var room in rooms) {
          final int roomId = room['id'] ?? 0;
          final String roomName = room['name'] ?? 'Ph�ng chi?u';
          
          lookupMap[roomId] = {
            'cinemaName': cinemaName,
            'roomName': roomName,
          };
        }
      }
      return lookupMap;
    } catch (e) {
      debugPrint('? L?i xy d?ng Lookup Map t?i Repository: $e');
      return lookupMap;
    }
  }

  // ── Thêm phim ──
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
    return await _apiService.createMovie(
      title: title,
      duration: duration,
      description: description,
      posterUrl: posterUrl,
      genres: genres,
      directors: directors,
      releaseDate: releaseDate,
      endDate: endDate,
      ageRating: ageRating,
      language: language,
    );
  }

  // ── Sửa phim ──
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
    return await _apiService.updateMovie(
      movieId,
      title: title,
      duration: duration,
      description: description,
      posterUrl: posterUrl,
      genres: genres,
      directors: directors,
      releaseDate: releaseDate,
      endDate: endDate,
      ageRating: ageRating,
      language: language,
    );
  }

  // ── Xóa phim ──
  Future<void> deleteMovie(int movieId) async {
    await _apiService.deleteMovie(movieId);
  }
}