import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../profile/providers/profile_provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  String _getFormattedDate() {
    final now = DateTime.now();
    final weekdays = [
      'Chủ Nhật',
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
    ];
    final weekday = weekdays[now.weekday % 7];
    return '$weekday, ${now.day} tháng ${now.month}';
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final user = profileProvider.user;
    final userName = user?.name ?? 'Khách';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getFormattedDate(),
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Chào, $userName ',
                  style: AppTextStyles.headlineLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Chào mừng bạn đã trở lại',
            style: AppTextStyles.bodyLarge.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
