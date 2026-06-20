import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';
import 'package:tet/core/l10n/app_localizations.dart';

class TicketDateRow extends StatelessWidget {
  final String timeStr;
  final String dateStr;
  final String roomNameText;
  final String seatsLabel;

  const TicketDateRow({
    super.key,
    required this.timeStr,
    required this.dateStr,
    required this.roomNameText,
    required this.seatsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month, color: Colors.black54, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(timeStr, style: AppTextStyles.titleMedium.copyWith(color: Colors.black)),
                Text(dateStr, style: AppTextStyles.bodyMedium.copyWith(color: Colors.black54)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.chair_alt_outlined, color: Colors.black54, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(roomNameText, style: AppTextStyles.bodyMedium.copyWith(color: Colors.black54)),
                Text("${AppLocalizations.of(context)!.payment_seat} $seatsLabel", style: AppTextStyles.titleMedium.copyWith(color: Colors.black)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
