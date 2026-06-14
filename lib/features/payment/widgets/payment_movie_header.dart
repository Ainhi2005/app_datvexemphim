import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/booking_selection.dart';

class PaymentMovieHeader extends StatelessWidget {
  final BookingSelection selection;
  final DateTime? showTimeDate;

  const PaymentMovieHeader({
    super.key,
    required this.selection,
    required this.showTimeDate,
  });

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return "Đang cập nhật...";
    return "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} - ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            selection.movie.posterUrl,
            width: 90,
            height: 130,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selection.movie.title,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _iconText(Icons.movie_creation_outlined, selection.movie.formattedGenres),
              const SizedBox(height: 8),
              _iconText(Icons.location_on_outlined, selection.cinemaName),
              const SizedBox(height: 8),
              _iconText(Icons.access_time, _formatDateTime(showTimeDate)),
            ],
          ),
        ),
      ],
    );
  }
}
