import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';

class TicketIconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;
  final double iconSize;

  const TicketIconText({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor = Colors.black54,
    this.textColor = Colors.black54,
    this.iconSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: iconSize, color: iconColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(color: textColor, fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
