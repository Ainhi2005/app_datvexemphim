// lib/features/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: Navigator.canPop(context)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, provider, child) {
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
                    title: AppStrings.myTickets,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TicketListScreen()),
                    ),
                  ),
                  ProfileMenuItem(
                    icon: Icons.shopping_cart_outlined,
                    title: AppStrings.paymentHistory,
                    onTap: () => SnackbarUtils.showSuccess(
                      context,
                      'Chức năng lịch sử giao dịch đang được phát triển',
                    ),
                  ),
                  ProfileMenuItem(
                    icon: Icons.language_outlined,
                    title: AppStrings.changeLanguage,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangeLanguageScreen()),
                    ),
                  ),
                  ProfileMenuItem(
                    icon: Icons.lock_outline,
                    title: AppStrings.changePassword,
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
                            AppRoutes.login,
                            (route) => false,
                          );
                        }
                      },
                      icon: const Icon(Icons.logout, color: AppColors.secondary),
                      label: Text(
                        AppStrings.logout,
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