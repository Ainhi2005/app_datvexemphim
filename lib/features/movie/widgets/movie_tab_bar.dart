import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'package:tet/core/l10n/app_localizations.dart';

class MovieTabBar extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const MovieTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            _buildTabItem(context, AppLocalizations.of(context)!.home_now_playing, 0),
            _buildTabItem(context, AppLocalizations.of(context)!.home_coming_soon, 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, String title, int index) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Center(
            child: Text(
              title,
              style: AppTextStyles.button.copyWith(
                color: isSelected ? AppColors.textButton : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
