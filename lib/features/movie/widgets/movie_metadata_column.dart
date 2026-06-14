import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/movie.dart';

class MovieMetadataColumn extends StatelessWidget {
  final Movie movie;
  const MovieMetadataColumn({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetaItem("Movie genre:", movie.formattedGenres),
        const SizedBox(height: 16),
        _buildMetaItem("Censorship:", movie.ageRating),
        const SizedBox(height: 16),
        _buildMetaItem("Language:", movie.language),
      ],
    );
  }

  Widget _buildMetaItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleSmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
