import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';

class PaymentRowInfo extends StatelessWidget {
  final String label;
  final String value;

  const PaymentRowInfo({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyLarge.copyWith(color: Colors.white)),
        Text(value, style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
