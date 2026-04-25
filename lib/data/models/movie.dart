class Movie {
  final String id;
  final String title;
  final String duration;
  final String genre;
  final double rating;
  final int reviewCount;
  final String posterUrl;
  final String? releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.duration,
    required this.genre,
    this.rating = 0,
    this.reviewCount = 0,
    required this.posterUrl,
    this.releaseDate,
  });
}