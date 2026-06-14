// lib/features/profile/screens/change_language_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../widgets/language_option.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  String _selectedLanguage = AppStrings.vietnamese;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.changeLanguage, style: AppTextStyles.headlineMedium),
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
            LanguageOption(
              language: AppStrings.vietnamese,
              flag: '🇻🇳',
              isSelected: _selectedLanguage == AppStrings.vietnamese,
              onTap: () => setState(() => _selectedLanguage = AppStrings.vietnamese),
            ),
            const SizedBox(height: 16),
            LanguageOption(
              language: AppStrings.english,
              flag: '🇬🇧',
              isSelected: _selectedLanguage == AppStrings.english,
              onTap: () => setState(() => _selectedLanguage = AppStrings.english),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  SnackbarUtils.showSuccess(context, AppStrings.languageChanged);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: Text(
                  AppStrings.continueText,
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
