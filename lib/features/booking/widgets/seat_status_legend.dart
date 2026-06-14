import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class SeatStatusLegend extends StatelessWidget {
  const SeatStatusLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendStatusItem("Có sẵn", AppColors.surface), // Thay 0xFF262A34
          const SizedBox(width: 28),
          _legendStatusItem("Đã đặt", AppColors.textPrimary.withValues(alpha: 0.04)), // Thay white.withOpacity
          const SizedBox(width: 28),
          _legendStatusItem("Đang chọn", AppColors.secondary, hasBorder: true),
        ],
      ),
    );
  }

  Widget _legendStatusItem(String title, Color color, {bool hasBorder = false}) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: hasBorder ? Border.all(color: AppColors.textPrimary, width: 0.8) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
