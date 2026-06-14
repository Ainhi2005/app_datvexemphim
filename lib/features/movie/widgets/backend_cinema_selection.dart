import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/showtime_provider.dart';

class BackendCinemaSelection extends StatelessWidget {
  final ShowtimeProvider showtimeProvider;

  const BackendCinemaSelection({
    super.key,
    required this.showtimeProvider,
  });

  @override
  Widget build(BuildContext context) {
    if (showtimeProvider.selectedDate == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "Vui lòng chọn ngày chiếu",
            style: TextStyle(
              color: Colors.white30,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    final availableCinemas = showtimeProvider.getCinemasBySelectedDate();

    if (availableCinemas.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "Không có suất chiếu nào cho ngày này",
            style: TextStyle(
              color: Colors.white30,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...availableCinemas.map((cinemaName) {
          bool isCinemaSelected = showtimeProvider.selectedCinema == cinemaName;

          final currentShowtimes = showtimeProvider.allShowtimes.where((st) {
            return st.formattedDate == showtimeProvider.selectedDate &&
                st.cinemaName == cinemaName;
          }).toList();

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCinemaSelected
                    ? AppColors.secondary.withValues(alpha: 0.5)
                    : Colors.white10,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Toggle selection if already selected
                    if (isCinemaSelected) {
                      showtimeProvider.selectCinema(""); // Clear selection
                    } else {
                      showtimeProvider.selectCinema(cinemaName);
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          cinemaName,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCinemaSelected
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white70,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCinemaSelected) ...[
                  const SizedBox(height: 16),
                  Text(
                    "2D PHỤ ĐỀ",
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: currentShowtimes.map((st) {
                        final timeStr = st.formattedTime;
                        bool isTimeSelected =
                            showtimeProvider.selectedShowtime?.id == st.id;

                        return GestureDetector(
                          onTap: () => showtimeProvider.selectShowtime(st),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isTimeSelected
                                  ? AppColors.secondary
                                  : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isTimeSelected
                                    ? AppColors.secondary
                                    : Colors.white10,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  timeStr,
                                  style: TextStyle(
                                    color: isTimeSelected
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}
