import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'package:tet/core/l10n/app_localizations.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.auth_terms_and_privacy,
      style: AppTextStyles.bodyMedium.copyWith(fontSize: 10),
      textAlign: TextAlign.center,
    );
  }
}
