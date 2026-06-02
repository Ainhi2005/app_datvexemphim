import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 38, 38, 38), // Slate 800
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF334155), width: 1),
        ),
        child: TextField(
          style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Tìm kiếm phim, rạp...',
            hintStyle: AppTextStyles.bodyLarge.copyWith(
              color: Colors.grey.shade400,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.secondary,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }
}
