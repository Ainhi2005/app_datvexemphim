// lib/presentation/movie/screens/movie_detail_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../data/models/movie.dart';
import '../../movie/providers/movie_detail_provider.dart';
import '../providers/showtime_provider.dart';
import '../providers/rating_provider.dart'; // Nạp tầng xử lý đánh giá phim
import '../widgets/movie_rating_section.dart';
import '../widgets/movie_metadata_column.dart';
import '../widgets/movie_storyline_section.dart';
import '../widgets/horizontal_director_list.dart';
import '../widgets/smart_date_selection.dart';
import '../widgets/backend_cinema_selection.dart';
import '../widgets/continue_floating_button.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isMovieDataLoaded = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    final Movie movie = args as Movie;
    final movieDetailProvider = Provider.of<MovieDetailProvider>(context);
    final showtimeProvider = Provider.of<ShowtimeProvider>(context);
    final ratingProvider = Provider.of<RatingProvider>(context);

    // Kích hoạt nạp thông tin mô tả bộ phim và danh sách rating động
    if (!_isMovieDataLoaded) {
      Future.microtask(() {
        movieDetailProvider.loadMovieDetailData(movie.id);
        ratingProvider.fetchRatings(movie.id);
        showtimeProvider.fetchShowtimes(movie.id);
      });
      _isMovieDataLoaded = true;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Hiệu ứng Ảnh nền lớn phía sau (Blur)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: movie.posterUrl.isNotEmpty
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(movie.posterUrl, fit: BoxFit.cover),
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, AppColors.background],
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(color: Colors.grey[900]),
          ),

          // 3. Khối nội dung cuộn chính
          movieDetailProvider.isLoading
              ? const Center(child: LoadingIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.12,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 120,
                              height: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  movie.posterUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    movie.heroName,
                                    style: AppTextStyles.titleSmall.copyWith(
                                      color: AppColors.secondary,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    movie.title,
                                    style: AppTextStyles.headlineMedium
                                        .copyWith(fontSize: 22),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${movie.formattedDuration} • ${movie.formattedReleaseDate}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  if (movie.isComingSoon) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Dự kiến khởi chiếu: ${movie.formattedReleaseDate}',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Section hiển thị Điểm Đánh giá lấy động từ RatingProvider mới gộp bộ chọn sao tương tác
                        MovieRatingSection(
                          movieId: movie.id,
                          averageScore: ratingProvider.averageScore,
                          totalRatings: ratingProvider.totalRatings,
                        ),
                        const SizedBox(height: 24),

                        MovieMetadataColumn(movie: movie),
                        const SizedBox(height: 24),

                        MovieStorylineSection(movie: movie),
                        const SizedBox(height: 24),

                        HorizontalDirectorList(movie: movie),
                        const SizedBox(height: 24),

                        if (!movie.isComingSoon) ...[
                          SmartDateSelection(
                            showtimeProvider: showtimeProvider,
                          ),
                          const SizedBox(height: 24),
                          BackendCinemaSelection(
                            showtimeProvider: showtimeProvider,
                          ),
                        ] else ...[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                "Phim sắp ra mắt, vui lòng quay lại sau!",
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),

          // 4. Thanh điều hướng đặt vé nổi dưới cùng màn hình (Chỉ hiện nếu phim đang chiếu)
          if (!movieDetailProvider.isLoading && !movie.isComingSoon)
            ContinueFloatingButton(
              showtimeProvider: showtimeProvider,
              movie: movie,
            ),

          // 2. Nút Quay Lại (Back)
          Positioned(
            top: 50,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
