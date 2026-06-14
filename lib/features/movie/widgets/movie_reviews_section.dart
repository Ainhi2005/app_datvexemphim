import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/section_header.dart';
import '../providers/rating_provider.dart';

class MovieReviewsSection extends StatelessWidget {
  const MovieReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RatingProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: AppColors.secondary),
            ),
          );
        }

        final ratings = provider.ratings;

        if (ratings.isEmpty) {
          return const SizedBox.shrink(); // Hide section if no reviews
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: "Đánh giá từ khán giả",
              showSeeAll: false,
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ratings.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final rating = ratings[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey[800],
                            backgroundImage:
                                rating.userAvatar != null &&
                                    rating.userAvatar!.isNotEmpty
                                ? NetworkImage(rating.userAvatar!)
                                : null,
                            child:
                                rating.userAvatar == null ||
                                    rating.userAvatar!.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              rating.userName,
                              style: AppTextStyles.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            rating.score.toStringAsFixed(1),
                            style: AppTextStyles.titleSmall,
                          ),
                        ],
                      ),
                      if (rating.review != null &&
                          rating.review!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          rating.review!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
