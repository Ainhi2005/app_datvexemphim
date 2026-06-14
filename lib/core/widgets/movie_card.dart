import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../../data/models/movie.dart';
import '../../routes/app_routes.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isNowPlaying;

  const MovieCard({super.key, required this.movie, this.isNowPlaying = false});

  @override
  Widget build(BuildContext context) {
    if (isNowPlaying) {
      return Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.cardColor, AppColors.primary],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  Image.network(
                    movie.posterUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: AppColors.primary,
                      child: const Icon(Icons.movie, size: 50, color: AppColors.textSecondary),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 14, color: AppColors.rating),
                          const SizedBox(width: 4),
                          Text(
                            '${movie.rating}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title.toUpperCase(),
                    style: AppTextStyles.titleSmall.copyWith(
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movie.title,
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      // SỬA: dùng formattedDuration (String)
                      Text(movie.formattedDuration, style: AppTextStyles.bodyMedium),
                      const SizedBox(width: 12),
                      Icon(Icons.category, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      // SỬA: dùng formattedGenres (String)
                      Text(movie.formattedGenres, style: AppTextStyles.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: AppColors.rating),
                      const SizedBox(width: 4),
                      Text(
                        '${movie.rating} (${movie.reviewCount})',
                        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.rating),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.movieDetail,
            arguments: movie,
          );
        },
        child: Container(
          width: 140,
          margin: const EdgeInsets.only(right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    movie.posterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.cardColor,
                      child: const Icon(Icons.movie, size: 40, color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                movie.title,
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                movie.formattedGenres,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white60,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, size: 12, color: AppColors.secondary),
                  const SizedBox(width: 4),
                  Text(
                    movie.formattedReleaseDate,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}