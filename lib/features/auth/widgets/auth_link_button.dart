import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class AuthLinkButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const AuthLinkButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
