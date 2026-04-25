import '../models/movie.dart';
import '../models/news_item.dart';

class MockApiService {
  Future<List<Movie>> getNowPlayingMovies() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      Movie(
        id: '1',
        title: 'Avengers - Infinity War',
        duration: '2h29m',
        genre: 'Action, adventure, sci-fi',
        rating: 4.8,
        reviewCount: 1222,
        posterUrl: 'https://image.tmdb.org/t/p/w500/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg',
      ),
      Movie(
        id: '2',
        title: 'Spider-Man: No Way Home',
        duration: '2h28m',
        genre: 'Action, adventure, fantasy',
        rating: 4.9,
        reviewCount: 2150,
        posterUrl: 'https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg',
      ),
      Movie(
        id: '3',
        title: 'Black Adam',
        duration: '2h25m',
        genre: 'Action, fantasy, sci-fi',
        rating: 4.7,
        reviewCount: 1850,
        posterUrl: 'https://image.tmdb.org/t/p/w500/3zXceNTtyj5FLjwQXuPvLYK5YYL.jpg',
      ),
      Movie(
        id: '4',
        title: 'Wakanda Forever',
        duration: '2h41m',
        genre: 'Action, drama, sci-fi',
        rating: 4.8,
        reviewCount: 2100,
        posterUrl: 'https://image.tmdb.org/t/p/w500/sv1xJUazXeYqALzczSZ3O6nkH75.jpg',
      ),
    ];
  }

  Future<List<Movie>> getComingSoonMovies() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      Movie(
        id: '5',
        title: 'Avatar 2: The Way of Water',
        duration: '3h12m',
        genre: 'Adventure, Sci-fi',
        rating: 0,
        reviewCount: 0,
        posterUrl: 'https://image.tmdb.org/t/p/w500/6LJFjUsrU1v9m0fK9x6jZ8Xq1jI.jpg',
        releaseDate: '20.12.2022',
      ),
      Movie(
        id: '6',
        title: 'Ant-Man 3: Quantumania',
        duration: '2h05m',
        genre: 'Adventure, Sci-fi',
        rating: 0,
        reviewCount: 0,
        posterUrl: 'https://image.tmdb.org/t/p/w500/ngl2FKBlU4fhbdsrtdom9LVLBXw.jpg',
        releaseDate: '25.12.2022',
      ),
      Movie(
        id: '7',
        title: 'The Marvels',
        duration: '2h15m',
        genre: 'Action, Sci-fi',
        rating: 0,
        reviewCount: 0,
        posterUrl: 'https://image.tmdb.org/t/p/w500/9GBhzXMFjgcZ3FdR9w3bUMMTps5.jpg',
        releaseDate: '27.12.2022',
      ),
    ];
  }

  Future<List<NewsItem>> getMovieNews() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      NewsItem(
        id: '1',
        title: 'When The Batman 2 Starts Filming Reportedly Revealed',
        imageUrl: 'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg',
      ),
      NewsItem(
        id: '1',
        title: 'When The Batman 2 Starts Filming Reportedly Revealed',
        imageUrl: 'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg',
      ),
      NewsItem(
        id: '1',
        title: 'When The Batman 2 Starts Filming Reportedly Revealed',
        imageUrl: 'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg',
      ),
      NewsItem(
        id: '1',
        title: 'When The Batman 2 Starts Filming Reportedly Revealed',
        imageUrl: 'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg',
      ),
    ];
  }
}