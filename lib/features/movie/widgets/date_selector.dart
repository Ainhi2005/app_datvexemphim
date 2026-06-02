// lib/features/movie/widgets/date_selector.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class DateSelector extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const DateSelector({
    super.key,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              '${date.day}',
              style: AppTextStyles.headlineMedium.copyWith(
                color: isSelected ? AppColors.secondary : AppColors.textPrimary,
                fontSize: isSelected ? 28 : 22,
              ),
            ),
            Text(
              date.day == DateTime.now().day
                  ? 'Hôm nay'
                  : '0${date.day}-T${date.month}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected
                    ? AppColors.secondary
                    : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
