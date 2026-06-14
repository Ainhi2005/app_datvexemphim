import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/payment_provider.dart';

class PaymentMethodTile extends StatelessWidget {
  final PaymentProvider provider;
  final String title;
  final String methodCode;
  final String logoPath;

  const PaymentMethodTile({
    super.key,
    required this.provider,
    required this.title,
    required this.methodCode,
    required this.logoPath,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = provider.selectedMethod == methodCode;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: AppColors.secondary, width: 1) : null,
      ),
      child: ListTile(
        onTap: () => provider.selectMethod(methodCode),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.account_balance_wallet, color: Colors.blue),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          color: isSelected ? AppColors.secondary : Colors.grey,
        ),
      ),
    );
  }
}
