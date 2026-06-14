import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/auth_text_field.dart';
import '../../../routes/app_routes.dart';
import '../providers/auth_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../core/utils/remember_me_storage.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_link_button.dart';
import '../widgets/remember_me_checkbox.dart';
import '../widgets/terms_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Load thông tin đã lưu khi vào màn hình
  Future<void> _loadRememberedCredentials() async {
    final remembered = await RememberMeStorage.isRemembered();
    if (remembered) {
      final email = await RememberMeStorage.getSavedEmail() ?? '';
      final password = await RememberMeStorage.getSavedPassword() ?? '';
      if (mounted) {
        setState(() {
          _rememberMe = true;
          _emailController.text = email;
          _passwordController.text = password;
        });
      }
    }
  }

  // === HÀM XỬ LÝ ĐĂNG NHẬP CHUẨN HOÁ ===
  Future<void> _handleLogin() async {
    // 1. Kiểm tra Lỗi tĩnh (Validation)
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    // Thực hiện gọi API đăng nhập
    final success = await authProvider.loginWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );

    // KIỂM TRA BẮT BUỘC: Đảm bảo widget còn mounted sau lệnh await bất đồng bộ
    if (!mounted) return;

    if (success) {
      await RememberMeStorage.saveCredentials(
        rememberMe: _rememberMe,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      // Tải thông tin Profile để kiểm tra vai trò (Role)
      final profileProvider = context.read<ProfileProvider>();
      await profileProvider.fetchProfile();

      if (!mounted) return;

      if (profileProvider.isAdmin) {
        // Nếu là Admin, hiển thị lựa chọn đường đi
        _showRoleSelectionDialog(context);
      } else {
        // Điều hướng về trang MainScreen thông thường
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
      }
    } else {
      // BẮT LỖI ĐỘNG: Hiển thị Snackbar thông điệp lỗi chuẩn từ Backend
      if (authProvider.errorMessage != null) {
        SnackbarUtils.showError(context, authProvider.errorMessage!);
        authProvider.clearError(); // Dọn dẹp bộ nhớ lỗi sau khi hiển thị
      }
    }
  }

  void _showRoleSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Center(
          child: Text(
            'QUYỀN TRUY CẬP ADMIN',
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Tài khoản của bạn có quyền Quản trị viên. Bạn muốn tiếp tục vào trang quản trị hay vào trải nghiệm đặt vé?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.adminDashboard, (route) => false);
              },
              child: const Text('Vào Trang Quản Trị', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.amber),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
              },
              child: const Text('Trải Nghiệm Mua Vé', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TỐI ƯU: Chỉ watch biến isLoading để render nút bấm và hiệu ứng xoay vòng
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.signIn, actions: []),
      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    AuthTextField(
                      hint: AppStrings.email,
                      prefixIcon: Icons.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterEmail;
                        }
                        final emailRegex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Định dạng email không hợp lệ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      hint: AppStrings.password,
                      prefixIcon: Icons.lock_outline,
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) => value == null || value.isEmpty
                          ? AppStrings.pleaseEnterPassword
                          : null,
                    ),
                    RememberMeCheckbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    AuthButton(
                      text: AppStrings.continueBtn,
                      onPressed: _handleLogin,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 24),
                    AuthLinkButton(
                      text: AppStrings.dontHaveAccount,
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.register,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const TermsText(),
                  ],
                ),
              ),
            ),
            if (isLoading) const LoadingIndicator(),
          ],
        ),
      ),
    );
  }
}