import 'package:flutter/material.dart';
import '../../../data/repositories/movie_repository.dart';
import '../../../data/models/movie.dart';
import '../../../data/models/news_item.dart';

class HomeProvider extends ChangeNotifier {
  final MovieRepository _repository = MovieRepository();

  List<Movie> _nowPlaying = [];
  List<Movie> _comingSoon = [];
  List<NewsItem> _news = [];
  bool _isLoading = true;

  List<Movie> get nowPlaying => _nowPlaying;
  List<Movie> get comingSoon => _comingSoon;
  List<NewsItem> get news => _news;
  bool get isLoading => _isLoading;

  HomeProvider() {
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    _isLoading = true;
    notifyListeners();

    final results = await Future.wait([
      _repository.getNowPlaying(),
      _repository.getComingSoon(),
      _repository.getNews(),
    ]);

    _nowPlaying = results[0] as List<Movie>;
    _comingSoon = results[1] as List<Movie>;
    _news = results[2] as List<NewsItem>;
    _isLoading = false;
    notifyListeners();
  }
}