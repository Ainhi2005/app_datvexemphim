import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
/// Indicator loading dùng chung.
/// Có thể mở rộng: thay đổi kích thước, màu sắc.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.secondary),
    );
  }
}