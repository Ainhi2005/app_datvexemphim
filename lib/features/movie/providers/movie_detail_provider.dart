// lib/presentation/movie/providers/movie_detail_provider.dart
import 'package:flutter/material.dart';
import '../../../data/models/showtime.dart';
import '../../../data/services/movie_api_service.dart';
// Giả định bạn có ShowtimeApiService riêng, hoặc tích hợp chung vào MovieApiService
import '../../../data/services/showtime_api_service.dart'; 

class MovieDetailProvider extends ChangeNotifier {
  final MovieApiService _movieService = MovieApiService();
  final ShowtimeApiService _showtimeService = ShowtimeApiService();

  List<Showtime> _allShowtimes = [];
  double _averageScore = 0.0;
  int _totalRatings = 0;
  bool _isLoading = true;
  String? _error;

  DateTime? _selectedDate;
  String? _selectedCinemaName;
  Showtime? _selectedShowtime;

  // Getters
  List<Showtime> get allShowtimes => _allShowtimes;
  double get averageScore => _averageScore;
  int get totalRatings => _totalRatings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get selectedDate => _selectedDate;
  String? get selectedCinemaName => _selectedCinemaName;
  Showtime? get selectedShowtime => _selectedShowtime;

  Future<void> loadMovieDetailData(int movieId) async {
    _isLoading = true;
    _error = null;
    _selectedDate = null;
    _selectedCinemaName = null;
    _selectedShowtime = null;
    notifyListeners();

    try {
      // Gọi đồng bộ bất đồng bộ song song cả 2 API để tối ưu thời gian phản hồi
      final results = await Future.wait([
        _showtimeService.getShowtimesByMovieId(movieId), // Hoặc hàm tương đương xử lý gọi GET /showtimes?movieId=X
        _movieService.getMovieRatingStats(movieId),
      ]);

      _allShowtimes = results[0] as List<Showtime>;
      
      final ratingStats = results[1] as Map<String, dynamic>;
      _averageScore = ratingStats['averageScore'];
      _totalRatings = ratingStats['totalRatings'];

    } catch (e) {
      _error = e.toString();
      debugPrint('MovieDetailProvider error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    _selectedCinemaName = null;
    _selectedShowtime = null;
    notifyListeners();
  }

  void selectCinema(String cinemaName) {
    if (_selectedCinemaName == cinemaName) {
      _selectedCinemaName = null; // Toggle đóng/mở rạp
    } else {
      _selectedCinemaName = cinemaName;
    }
    _selectedShowtime = null;
    notifyListeners();
  }

  void selectShowtime(Showtime showtime) {
    _selectedShowtime = showtime;
    notifyListeners();
  }
}