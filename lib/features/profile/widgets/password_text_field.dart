import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class PasswordTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const PasswordTextField({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.background,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.surface, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondary, width: 1),
        ),
      ),
    );
  }
}
