// lib/presentation/movie/providers/showtime_provider.dart
import 'package:flutter/material.dart';
import '../../../data/models/showtime.dart';
import '../../../data/repositories/movie_repository.dart';

class ShowtimeProvider extends ChangeNotifier {
  final MovieRepository _movieRepository = MovieRepository();

  List<Showtime> _allShowtimes = [];
  bool _isLoading = false;
  String? _error;

  String? _selectedDate; 
  String? _selectedCinema; 
  Showtime? _selectedShowtime; 

  // 💡 BỘ NHỚ ĐỆM TOÀN CỤC: { roomId: { "cinemaName": "...", "roomName": "..." } }
  Map<int, Map<String, String>> _globalRoomsMap = {};

  List<Showtime> get allShowtimes => _allShowtimes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedDate => _selectedDate;
  String? get selectedCinema => _selectedCinema;
  Showtime? get selectedShowtime => _selectedShowtime;

  Future<void> fetchShowtimes(int movieId) async {
    _isLoading = true;
    _error = null;
    Future.microtask(() => notifyListeners());

    try {
      // 💡 BƯỚC 1: Nạp bản đồ tra cứu toàn bộ phòng rạp vào RAM (Chỉ chạy duy nhất 1 lần khi mở app)
      if (_globalRoomsMap.isEmpty) {
        _globalRoomsMap = await _movieRepository.buildGlobalRoomsLookupMap();
        debugPrint('Cached ${_globalRoomsMap.length} rooms');
      }

      // BƯỚC 2: Gọi 1 request duy nhất lấy danh sách suất chiếu của phim (Né hoàn toàn lỗi 429)
      final rawShowtimes = await _movieRepository.getShowtimesByMovieId(movieId);
      
      // BƯỚC 3: ĐẬP DATA TÊN RẠP VÀ PHÒNG CHIẾU TỪ BỘ NHỚ ĐỆM MAP VÀ LỌC CÁC SUẤT CHIẾU ĐÃ KẾT THÚC
      final now = DateTime.now();
      _allShowtimes = rawShowtimes.map((showtime) {
        if (_globalRoomsMap.containsKey(showtime.roomId)) {
          final info = _globalRoomsMap[showtime.roomId]!;
          return showtime.copyWith(
            roomName: info['roomName'],
            cinemaName: info['cinemaName'], // Đắp chuẩn tên rạp từ API /cinemas/:id/rooms
          );
        }
        return showtime;
      }).where((st) {
        // Lọc bỏ các suất chiếu trạng thái ENDED hoặc đã trôi qua thời gian hiện tại
        return st.status != 'ENDED' && st.startTime.isAfter(now);
      }).toList();

      // Sắp xếp suất chiếu theo thời gian tăng dần để UI hiển thị hợp lý hơn
      _allShowtimes.sort((a, b) => a.startTime.compareTo(b.startTime));

      debugPrint('First cinema: ${_allShowtimes.isNotEmpty ? _allShowtimes.first.cinemaName : "empty"}');

      // Đồng bộ trạng thái UI lịch chiếu
      _selectedDate = null;
      _selectedCinema = null;
      _selectedShowtime = null;

      if (_allShowtimes.isNotEmpty) {
        _selectedDate = getAvailableDates().first;
        final availableCinemas = getCinemasBySelectedDate();
        if (availableCinemas.isNotEmpty) {
          _selectedCinema = availableCinemas.first;
        }
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('ShowtimeProvider error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<String> getAvailableDates() {
    return _allShowtimes.map((st) => st.formattedDate).toSet().toList();
  }

  List<String> getCinemasBySelectedDate() {
    if (_selectedDate == null) return [];
    return _allShowtimes
        .where((st) => st.formattedDate == _selectedDate)
        .map((st) => st.cinemaName)
        .toSet()
        .toList();
  }

  void selectDate(String date) {
    _selectedDate = date;
    _selectedCinema = null; 
    _selectedShowtime = null;
    final availableCinemas = getCinemasBySelectedDate();
    if (availableCinemas.isNotEmpty) _selectedCinema = availableCinemas.first;
    notifyListeners();
  }

  void selectCinema(String cinemaName) {
    _selectedCinema = cinemaName;
    _selectedShowtime = null;
    notifyListeners();
  }

  void selectShowtime(Showtime showtime) {
    _selectedShowtime = showtime;
    notifyListeners();
  }
}