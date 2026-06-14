import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';

class TicketInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isBold;

  const TicketInfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.isBold = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
