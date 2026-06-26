// lib/features/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import 'package:tet/core/l10n/app_localizations.dart';
import '../../../routes/app_routes.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import 'change_language_screen.dart';
import 'change_password_screen.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/widgets/error_view.dart';
import '../../auth/providers/auth_provider.dart';
import '../../ticket/screens/ticket_list_screen.dart';
import '../../payment/screens/payment_history_screen.dart';
import '../../main/screens/main_screen.dart';
import '../../../core/constants/app_text_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            final authProvider = context.watch<AuthProvider>();
            
            if (!authProvider.isAuthenticated) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.account_circle_outlined, size: 100, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        "Đăng nhập để trải nghiệm",
                        style: AppTextStyles.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Xem vé đã đặt, lịch sử giao dịch và nhận nhiều ưu đãi hấp dẫn.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Đăng nhập / Đăng ký", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (provider.isLoading && provider.user == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.secondary),
              );
            }

            if (provider.error != null && provider.user == null) {
              return ErrorView(
                message: provider.error!,
                onRetry: () => provider.fetchProfile(),
              );
            }

            final user = provider.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  ProfileHeader(user: user),                  
                  const SizedBox(height: 40),
                  if(provider.isAdmin)...[ 
                    ProfileMenuItem(
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'Quản trị hệ thống ( Admin)',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.adminDashboard),
                  )
                  ]
                  ,
                  ProfileMenuItem(
                    icon: Icons.confirmation_num_outlined,
                    title: lang.profile_my_tickets,
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainScreen(initialIndex: 1)),
                      (route) => false,
                    ),
                  ),
                  ProfileMenuItem(
                    icon: Icons.shopping_cart_outlined,
                    title: lang.profile_payment_history,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PaymentHistoryScreen()),
                    ),
                  ),
                  ProfileMenuItem(
                    icon: Icons.language_outlined,
                    title: lang.profile_language,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangeLanguageScreen()),
                    ),
                  ),
                  ProfileMenuItem(
                    icon: Icons.lock_outline,
                    title: lang.profile_change_password,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        SnackbarUtils.showSuccess(context, 'Đang đăng xuất...');
                        await context.read<AuthProvider>().logout();
                        if (context.mounted) {
                          context.read<ProfileProvider>().clearUser();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.main,
                            (route) => false,
                          );
                        }
                      },
                      icon: const Icon(Icons.logout, color: AppColors.secondary),
                      label: Text(
                        lang.profile_logout,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}