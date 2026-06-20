import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../profile/screens/profile_screen.dart';
import '../../../routes/app_routes.dart';
import 'package:tet/core/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  String _getFormattedDate(BuildContext context) {
    final now = DateTime.now();
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('EEEE, d MMMM', locale).format(now);
  }

  void _showLoginRequired(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          AppLocalizations.of(context)!.common_login_required_title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          AppLocalizations.of(context)!.common_login_required_profile_msg,
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.common_login_later, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: Text(
              AppLocalizations.of(context)!.common_login,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    final profileProvider = context.watch<ProfileProvider>();
    final user = profileProvider.user;
    final userName = user?.name ?? lang.home_guest;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Bên trái: Lời chào và Ngày tháng
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getFormattedDate(context),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white60,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${lang.home_greeting} $userName,',
                  style: AppTextStyles.headlineLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lang.home_ready_to_watch,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // Bên phải: Avatar có viền glow
          GestureDetector(
            onTap: () {
              final isAuth = context.read<AuthProvider>().isAuthenticated;
              if (!isAuth) {
                // Khách vãng lai: hiển thị yêu cầu đăng nhập
                _showLoginRequired(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.8),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.surface,
                backgroundImage: user?.avatarUrl != null
                    ? NetworkImage(user!.avatarUrl!)
                    : null,
                child: user?.avatarUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 24,
                        color: AppColors.textSecondary,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
