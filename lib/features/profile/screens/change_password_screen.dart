// lib/features/profile/screens/change_password_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../providers/profile_provider.dart';
import '../widgets/password_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPwdController = TextEditingController();
  final _newPwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  @override
  void dispose() {
    _currentPwdController.dispose();
    _newPwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  Future<void> _onChangePassword() async {
    if (_newPwdController.text != _confirmPwdController.text) {
      SnackbarUtils.showError(context, AppStrings.passwordNotMatch);
      return;
    }

    final provider = context.read<ProfileProvider>();
    final success = await provider.changePassword(
      _currentPwdController.text,
      _newPwdController.text,
    );

    if (!mounted) return;

    if (success) {
      SnackbarUtils.showSuccess(context, AppStrings.changePasswordSuccess);
      Navigator.pop(context);
    } else {
      if (provider.error != null) SnackbarUtils.showError(context, provider.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ProfileProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.changePassword, style: AppTextStyles.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            PasswordTextField(
              hintText: AppStrings.currentPassword,
              controller: _currentPwdController,
            ),
            const SizedBox(height: 16),
            PasswordTextField(
              hintText: AppStrings.newPassword,
              controller: _newPwdController,
            ),
            const SizedBox(height: 16),
            PasswordTextField(
              hintText: AppStrings.confirmPassword,
              controller: _confirmPwdController,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _onChangePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                      )
                    : Text(
                        AppStrings.confirm,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textButton,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}