class Rating {
  final int id;
  final int userId;
  final int movieId;
  final double score;
  final String? review;
  final DateTime createdAt;
  final String userName;
  final String? userAvatar;

  Rating({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.score,
    this.review,
    required this.createdAt,
    required this.userName,
    this.userAvatar,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? json['user_id'] ?? 0,
      movieId: json['movieId'] ?? json['movie_id'] ?? 0,
      score: (json['score'] ?? 0).toDouble(),
      review: json['review'],
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
      userName: json['userName'] ?? json['user_name'] ?? 'Ẩn danh',
      userAvatar: json['userAvatar'] ?? json['user_avatar'],
    );
  }
}