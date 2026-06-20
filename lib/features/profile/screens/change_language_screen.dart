// lib/features/profile/screens/change_language_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tet/core/l10n/app_localizations.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/provider/locale_provider.dart';
import '../widgets/language_option.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  String? _selectedLanguageCode;

  @override
  Widget build(BuildContext context) {
    // 1. Lấy hàm dịch
    final lang = AppLocalizations.of(context)!;
    
    // 2. Lấy provider (không listen để không bị rebuild liên tục khi chọn)
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    // 3. Khởi tạo ngôn ngữ ban đầu đang được chọn
    _selectedLanguageCode ??= localeProvider.locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(lang.profile_language, style: AppTextStyles.headlineMedium),
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
              language: 'Tiếng Việt',
              flag: '🇻🇳',
              isSelected: _selectedLanguageCode == 'vi',
              onTap: () => setState(() => _selectedLanguageCode = 'vi'),
            ),
            const SizedBox(height: 16),
            LanguageOption(
              language: 'English',
              flag: '🇬🇧',
              isSelected: _selectedLanguageCode == 'en',
              onTap: () => setState(() => _selectedLanguageCode = 'en'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Cập nhật ngôn ngữ qua provider!
                  localeProvider.setLocale(Locale(_selectedLanguageCode!));
                  
                  SnackbarUtils.showSuccess(context, lang.common_success);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: Text(
                  lang.common_confirm,
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
