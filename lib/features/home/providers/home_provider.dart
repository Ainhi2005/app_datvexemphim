import 'package:flutter/material.dart';
import '../../../data/repositories/movie_repository.dart';
import '../../../data/models/movie.dart';

class HomeProvider extends ChangeNotifier {
  final MovieRepository _repository = MovieRepository();

  List<Movie> _nowPlaying = [];
  List<Movie> _comingSoon = [];
  List<Movie> _newsMovies = [];  // ĐỔI TỪ List<NewsItem> thành List<Movie>
  bool _isLoading = true;
  String? _error;

  List<Movie> get nowPlaying => _nowPlaying;
  List<Movie> get comingSoon => _comingSoon;
  List<Movie> get newsMovies => _newsMovies;  // ĐỔI TÊN
  bool get isLoading => _isLoading;
  String? get error => _error;

  HomeProvider() {
    fetchHomeData();
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> fetchHomeData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Gọi tuần tự (sequential) thay vì song song (Future.wait) 
      // để tránh bị chặn bởi giới hạn request của server (Lỗi 429 Too Many Requests)
      final nowPlayingList = await _repository.getNowPlaying();
      final comingSoonList = await _repository.getComingSoon();
      final allMoviesList = await _repository.getAllMovies();

      _nowPlaying = nowPlayingList;
      _comingSoon = comingSoonList;

      // Lấy 5 phim đầu tiên làm news
      _newsMovies = allMoviesList.take(5).toList();

      debugPrint('Loaded: ${_nowPlaying.length} now showing, ${_comingSoon.length} coming soon, ${_newsMovies.length} news');
    } catch (e) {
      _error = e.toString();
      debugPrint('HomeProvider error: $e');
    } finally {
      _isLoading = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }

// XÓA hàm _getMockNews() - không cần nữa
}