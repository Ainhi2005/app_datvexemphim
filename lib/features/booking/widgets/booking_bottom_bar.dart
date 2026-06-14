import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class BookingBottomBar extends StatelessWidget {
  final double totalPrice;
  final NumberFormat currencyFormatter;
  final VoidCallback? onSubmit;

  const BookingBottomBar({
    super.key,
    required this.totalPrice,
    required this.currencyFormatter,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Tổng thanh toán",
                  style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5), fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  "${currencyFormatter.format(totalPrice)} VND",
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                elevation: 0,
              ),
              onPressed: onSubmit,
              child: const Text(
                "Tiếp tục",
                style: TextStyle(
                  color: Colors.black, // Vẫn giữ màu đen cho chữ trên nền vàng (AppColors.secondary)
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
