import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/rating_provider.dart';
import 'package:tet/core/l10n/app_localizations.dart';

class MovieRatingSection extends StatefulWidget {
  final int movieId;
  final double averageScore;
  final int totalRatings;

  const MovieRatingSection({
    super.key,
    required this.movieId,
    required this.averageScore,
    required this.totalRatings,
  });

  @override
  State<MovieRatingSection> createState() => _MovieRatingSectionState();
}

class _MovieRatingSectionState extends State<MovieRatingSection> {
  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 28),
            const SizedBox(width: 10),
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.rating_understood,
              style: const TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRatingSubmission(
    int ratingValue,
    String reviewText,
  ) async {
    final ratingProvider = Provider.of<RatingProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? realUserToken = authProvider.token;

    double calculatedScore = ratingValue.toDouble();

      final lang = AppLocalizations.of(context)!;
      final defaultReview = lang.rating_default_review;
      final String? errorMessage = await ratingProvider.submitRating(
        movieId: widget.movieId,
        score: calculatedScore,
        review: reviewText.isEmpty ? defaultReview : reviewText,
        token: realUserToken,
      );

      if (!mounted) return;

      if (errorMessage != null) {
        _showErrorDialog(context, lang.rating_error_title, errorMessage);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              lang.rating_success_msg,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
  }

  void _showRatingBottomSheet() {
    int selectedStars = 0;
    final TextEditingController reviewController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppLocalizations.of(context)!.rating_dialog_title, style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        int starValue = index + 1;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedStars = starValue;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.star,
                              color: starValue <= selectedStars
                                  ? Colors.amber
                                  : Colors.grey[700],
                              size: 40,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: reviewController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.rating_input_hint,
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: AppColors.cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: selectedStars == 0
                            ? null
                            : () {
                                Navigator.pop(context); // Đóng bottom sheet
                                _handleRatingSubmission(
                                  selectedStars,
                                  reviewController.text.trim(),
                                );
                              },
                        child: Text(
                          AppLocalizations.of(context)!.rating_submit_btn,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAllReviewsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Consumer<RatingProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  );
                }

                final ratings = provider.ratings;

                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 16),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.rating_audience_reviews,
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    if (ratings.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.rating_no_reviews,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: ratings.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final rating = ratings[index];
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
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
                                                    size: 18,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              rating.userName,
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!.rating_already_rated,
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                color: Colors.white54,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary
                                              .withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              rating.score.toStringAsFixed(1),
                                              style: AppTextStyles.titleSmall
                                                  .copyWith(
                                                color: AppColors.secondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (rating.review != null &&
                                      rating.review!.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      rating.review!,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RatingProvider>();
    
    // Ưu tiên dùng data từ provider (vừa fetch mới nhất), nếu provider rỗng thì dùng data cũ từ widget
    final double displayStars = provider.totalRatings > 0 ? provider.averageScore : widget.averageScore;
    final int displayTotal = provider.totalRatings > 0 ? provider.totalRatings : widget.totalRatings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: _showAllReviewsBottomSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.rating_review_tab, style: AppTextStyles.titleSmall),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(
                      " ${displayStars.toStringAsFixed(1)}",
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      " ($displayTotal)",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _showRatingBottomSheet,
              icon: const Icon(
                Icons.edit,
                size: 16,
                color: AppColors.secondary,
              ),
              label: Text(
                AppLocalizations.of(context)!.rating_rate_btn,
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
