import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_text_styles.dart';

class TicketQrSection extends StatelessWidget {
  final String orderId;

  const TicketQrSection({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QrImageView(
          data: orderId,
          version: QrVersions.auto,
          size: 80.0,
        ),
        const SizedBox(height: 12),
        Text(
          "Order ID: $orderId",
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
