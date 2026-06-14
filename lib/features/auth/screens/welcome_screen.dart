import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../widgets/auth_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // 1. Logo FILMGO & Tên ứng dụng ở trung tâm
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.movie_creation_outlined,
                        color: AppColors.secondary,
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'FILMGO',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w900,
                        fontSize: 36,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Đặt vé dễ dàng - Trải nghiệm tuyệt đỉnh",
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // 2. Nút Đăng nhập
              AuthButton(
                text: AppStrings.signIn,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
              ),
              const SizedBox(height: 16),

              // 3. Nút Đăng ký
              AuthButton(
                text: AppStrings.signUp,
                isOutlined: true,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.register);
                },
              ),
              const SizedBox(height: 16),

              // 4. Lựa chọn khách vãng lai
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Trải nghiệm ngay với vai khách',
                      style: TextStyle(
                        color: AppColors.secondary.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppColors.secondary.withOpacity(0.8),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
