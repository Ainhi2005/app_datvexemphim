import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ScreenArcIndicator extends StatelessWidget {
  const ScreenArcIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          height: 4,
          width: MediaQuery.of(context).size.width * 0.65,
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.2),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "MÀN HÌNH CHIẾU",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary.withValues(alpha: 0.4), // Thay white24
            fontSize: 9,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}
