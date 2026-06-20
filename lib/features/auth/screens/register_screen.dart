import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tet/core/l10n/app_localizations.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/auth_text_field.dart';
import '../../../routes/app_routes.dart';
import '../providers/auth_provider.dart';
import 'register_username_screen.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_link_button.dart';
import '../widgets/terms_text.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // === HÀM XỬ LÝ ĐĂNG KÝ CHUẨN HOÁ ===
  Future<void> _handleContinue() async {
    // 1. Kiểm tra Lỗi tĩnh (Validation)
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    
    // Gọi API đăng ký tài khoản mới
    final success = await authProvider.register(
      _emailController.text.trim(),
      _usernameController.text.trim(),
      _passwordController.text,
    );

    // KIỂM TRA BẮT BUỘC: Tránh lỗi rò rỉ context khi chuyển đổi màn hình bất đồng bộ
    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              RegisterUsernameScreen(username: _usernameController.text.trim()),
        ),
      );
    } else {
      // 2. BẮT LỖI ĐỘNG: Hiển thị lỗi động từ server (ví dụ: "Email này đã được sử dụng")
      if (authProvider.errorMessage != null) {
        SnackbarUtils.showError(context, authProvider.errorMessage!);
        authProvider.clearError(); // Dọn dẹp lỗi sau khi hiển thị xong
      }
    }
  }

  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    // TỐI ƯU: Chỉ watch duy nhất biến isLoading để tăng tốc độ render UI
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: CustomAppBar(title: lang.auth_sign_up, actions: const []),
      body: Stack(
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
                    hint: lang.auth_email,
                    prefixIcon: Icons.email,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return lang.val_please_enter_email;
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
                    hint: lang.auth_username,
                    prefixIcon: Icons.person,
                    controller: _usernameController,
                    validator: (value) => value == null || value.isEmpty
                        ? lang.val_please_enter_username
                        : null,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    hint: lang.auth_password,
                    prefixIcon: Icons.lock_outline,
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) => value == null || value.isEmpty
                        ? lang.val_please_enter_password
                        : null,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    hint: lang.auth_confirm_password,
                    prefixIcon: Icons.lock_outline,
                    controller: _confirmController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return lang.val_please_confirm_password;
                      }
                      if (value != _passwordController.text) {
                        return lang.val_password_not_match;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  AuthButton(
                    text: lang.auth_continue_btn,
                    onPressed: _handleContinue,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 24),
                  AuthLinkButton(
                    text: lang.auth_already_have_account,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
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
    );
  }
}