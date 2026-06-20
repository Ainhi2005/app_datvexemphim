import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'package:tet/core/l10n/app_localizations.dart';

class PaymentDiscountCodeBox extends StatelessWidget {
  const PaymentDiscountCodeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.local_offer_outlined, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.payment_discount_hint,
                hintStyle: AppTextStyles.bodyMedium,
                border: InputBorder.none,
                filled: false,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context)!.payment_apply,
              style: AppTextStyles.button.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
