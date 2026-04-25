import 'package:flutter/material.dart';
import '../../../data/models/movie_detail.dart';
import '../../../data/services/mock_movie_service.dart';

class MovieProvider extends ChangeNotifier {
  final MockMovieService _service = MockMovieService();

  List<MovieDetail> _nowPlayingMovies = [];
  List<MovieDetail> _comingSoonMovies = [];
  bool _isLoading = true;

  List<MovieDetail> get nowPlayingMovies => _nowPlayingMovies;
  List<MovieDetail> get comingSoonMovies => _comingSoonMovies;
  bool get isLoading => _isLoading;

  MovieProvider() {
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    _isLoading = true;
    notifyListeners();

    final allMovies = await _service.getMovies();

    // Tách thành 2 danh sách: Now playing và Coming soon
    _nowPlayingMovies = allMovies.where((m) =>
    m.releaseDate != '20.12.2022' &&
        m.releaseDate != '25.12.2022' &&
        m.releaseDate != 'MARCH 17'
    ).take(6).toList();

    _comingSoonMovies = allMovies.where((m) =>
    m.releaseDate == '20.12.2022' ||
        m.releaseDate == '25.12.2022' ||
        m.releaseDate == 'MARCH 17'
    ).toList();

    _isLoading = false;
    notifyListeners();
  }
}