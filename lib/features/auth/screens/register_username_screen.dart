import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'package:tet/core/l10n/app_localizations.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../routes/app_routes.dart';
import '../widgets/auth_button.dart';

class RegisterUsernameScreen extends StatelessWidget {
  final String username;
  const RegisterUsernameScreen({super.key, required this.username});

  void _handleDone(BuildContext context) {
    // Chuyển về màn hình đăng nhập để người dùng login bằng tài khoản mới
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(title: lang.auth_sign_up, actions: const []),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(lang.auth_welcome, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text(
              lang.auth_your_registered_username_is,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                username,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.secondary,
                ),
              ),
            ),
            const SizedBox(height: 32),
            AuthButton(
              text: lang.auth_continue_btn,
              onPressed: () => _handleDone(context),
            ),
          ],
        ),
      ),
    );
  }
}