import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class SeeAllButton extends StatelessWidget {
  final VoidCallback onTap;
  const SeeAllButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        'See all >',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondary),
      ),
    );
  }
}