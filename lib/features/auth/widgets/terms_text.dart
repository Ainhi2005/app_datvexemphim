import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.termsAndPrivacy,
      style: AppTextStyles.bodyMedium.copyWith(fontSize: 10),
      textAlign: TextAlign.center,
    );
  }
}
