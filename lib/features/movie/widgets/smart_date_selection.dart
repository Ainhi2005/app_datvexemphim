import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/section_header.dart';
import '../providers/showtime_provider.dart';

class SmartDateSelection extends StatelessWidget {
  final ShowtimeProvider showtimeProvider;

  const SmartDateSelection({
    super.key,
    required this.showtimeProvider,
  });

  @override
  Widget build(BuildContext context) {
    if (showtimeProvider.allShowtimes.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<String> availableDates = showtimeProvider.getAvailableDates();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Chọn ngày chiếu", showSeeAll: false),
        const SizedBox(height: 12),
        SizedBox(
          height: 95,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: availableDates.length,
            itemBuilder: (context, index) {
              final String dateStr = availableDates[index];
              bool isSelected = showtimeProvider.selectedDate == dateStr;

              final parts = dateStr.split('/');
              final String dayDisplay = parts.isNotEmpty ? parts[0] : '';
              final String monthDisplay = parts.length > 1 ? parts[1] : '';

              return GestureDetector(
                onTap: () => showtimeProvider.selectDate(dateStr),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondary.withValues(alpha: 0.15)
                        : AppColors.cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondary
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayDisplay,
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: isSelected
                              ? AppColors.secondary
                              : AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Thg $monthDisplay",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isSelected
                              ? AppColors.secondary
                              : AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
