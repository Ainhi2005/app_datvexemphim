import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tet/core/l10n/app_localizations.dart';
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
    _loadSavedAccounts();
    
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Load thông tin đã lưu khi vào màn hình
    List<Map<String, String>> _savedAccounts = [];

  // Load thông tin đã lưu khi vào màn hình
  Future<void> _loadSavedAccounts() async {
    final accounts = await RememberMeStorage.getSavedAccounts();
    if (mounted) {
      setState(() {
        _savedAccounts = accounts;
      });
    }
  }

  void _showSavedAccountsMenu() {
    if (_savedAccounts.isEmpty) return;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _savedAccounts.length,
          itemBuilder: (context, index) {
            final acc = _savedAccounts[index];
            return ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.grey, size: 36),
              title: Text(acc['email'] ?? '', style: const TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _emailController.text = acc['email'] ?? '';
                  _passwordController.text = acc['password'] ?? '';
                  _rememberMe = true;
                });
                Navigator.pop(context);
              },
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.redAccent),
                onPressed: () async {
                  await RememberMeStorage.removeAccount(acc['email']!);
                  Navigator.pop(context);
                  await _loadSavedAccounts();
                  if (_savedAccounts.isNotEmpty) {
                    _showSavedAccountsMenu();
                  }
                },
              ),
            );
          },
        );
      }
    );
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
      if (_rememberMe) {
          await RememberMeStorage.saveAccount(
            _emailController.text,
            _passwordController.text,
          );
        } else {
          await RememberMeStorage.removeAccount(_emailController.text);
        }

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
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.auth_admin_access,
            style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.auth_admin_dialog_msg,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
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
              child: Text(AppLocalizations.of(context)!.auth_admin_go_admin, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
              child: Text(AppLocalizations.of(context)!.auth_admin_go_user, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    // Lấy đối tượng dịch
    final lang = AppLocalizations.of(context)!;
    // TỐI ƯU: Chỉ watch biến isLoading để render nút bấm và hiệu ứng xoay vòng
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: CustomAppBar(title: lang.auth_sign_in, actions: const []),
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
                      hint: lang.auth_email,
                      prefixIcon: Icons.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: _savedAccounts.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.amber),
                              onPressed: _showSavedAccountsMenu,
                            )
                          : null,
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
                      hint: lang.auth_password,
                      prefixIcon: Icons.lock_outline,
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) => value == null || value.isEmpty
                          ? lang.val_please_enter_password
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
                      text: lang.auth_continue_btn,
                      onPressed: _handleLogin,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 24),
                    AuthLinkButton(
                      text: lang.auth_dont_have_account,
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