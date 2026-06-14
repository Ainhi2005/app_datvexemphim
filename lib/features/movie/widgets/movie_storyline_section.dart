import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/models/movie.dart';

class MovieStorylineSection extends StatefulWidget {
  final Movie movie;
  const MovieStorylineSection({super.key, required this.movie});

  @override
  State<MovieStorylineSection> createState() => _MovieStorylineSectionState();
}

class _MovieStorylineSectionState extends State<MovieStorylineSection> {
  bool _isStorylineExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Storyline", showSeeAll: false),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () =>
              setState(() => _isStorylineExpanded = !_isStorylineExpanded),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: Text(
              widget.movie.description,
              maxLines: _isStorylineExpanded ? 100 : 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
