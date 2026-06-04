// lib/features/auth/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/auth_text_field.dart';
import '../../../routes/app_routes.dart';
import '../providers/auth_provider.dart';
import '../../../core/utils/remember_me_storage.dart';

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
      // THỰC HIỆN LƯU MẬT KHẨU KHI THÀNH CÔNG
      await RememberMeStorage.saveCredentials(
        rememberMe: _rememberMe,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Điều hướng về trang MainScreen có thanh Bottom Navigation
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    } else {
      // BẮT LỖI ĐỘNG: Hiển thị Snackbar thông điệp lỗi chuẩn từ Backend
      if (authProvider.errorMessage != null) {
        SnackbarUtils.showError(context, authProvider.errorMessage!);
        authProvider.clearError(); // Dọn dẹp bộ nhớ lỗi sau khi hiển thị
      }
    }
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
                    Row(
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: AppColors.textSecondary,
                          ),
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: AppColors.secondary,
                            checkColor: Colors.black,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                        ),
                        Text(
                          'Nhớ mật khẩu',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        AppStrings.continueBtn,
                        style: AppTextStyles.button,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.register,
                        );
                      },
                      child: Text(
                        AppStrings.dontHaveAccount,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.termsAndPrivacy,
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
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