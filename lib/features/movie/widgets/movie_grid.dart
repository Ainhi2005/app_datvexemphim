import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/movie.dart';
import '../../../routes/app_routes.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final bool isNowPlaying;

  const MovieGrid({
    super.key,
    required this.movies,
    required this.isNowPlaying,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Center(
        child: Text(
          isNowPlaying ? 'Không có phim đang chiếu' : 'Không có phim sắp chiếu',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        // 💡 ĐỒI: Truyền thêm `context` vào hàm build card để có thể sử dụng Navigator
        return _buildMovieCard(context, movies[index], isNowPlaying);
      },
    );
  }

  Widget _buildMovieCard(BuildContext context, Movie movie, bool isNowPlaying) {
    // 💡 XOAY CHUYỂN CỐT LÕI: Bọc GestureDetector ngoài cùng để bắt sự kiện click cho cả ô phim
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.movieDetail,// Khớp với cấu trúc tên đặt cho Route chi tiết phim của bạn
          arguments: movie, // BẮT BUỘC: Truyền dữ liệu phim thật sang màn hình Detail
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // ==========================
            // POSTER
            // ==========================
            Expanded(
              flex: 7,
              child: SizedBox(
                width: double.infinity,
                child: Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: AppColors.primary,
                      child: const Center(
                        child: Icon(
                          Icons.movie,
                          size: 50,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ==========================
            // CONTENT
            // ==========================
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TÊN PHIM
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // THỜI LƯỢNG + THỂ LOẠI
                    Text(
                      '${movie.formattedDuration} • ${movie.formattedGenres}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),

                    const Spacer(),

                    if (isNowPlaying)
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: AppColors.rating,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${movie.rating} (${movie.reviewCount})',
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.rating,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              movie.formattedReleaseDate,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}