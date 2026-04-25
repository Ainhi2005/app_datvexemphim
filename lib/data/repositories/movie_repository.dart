import '../models/movie.dart';
import '../models/news_item.dart';
import '../services/mock_api_service.dart';

class MovieRepository {
  final MockApiService _apiService = MockApiService();

  Future<List<Movie>> getNowPlaying() => _apiService.getNowPlayingMovies();
  Future<List<Movie>> getComingSoon() => _apiService.getComingSoonMovies();
  Future<List<NewsItem>> getNews() => _apiService.getMovieNews();
}