import 'package:flutter/material.dart';
import 'package:tet/core/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class RememberMeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? label;

  const RememberMeCheckbox({
    super.key,
    this.value = false,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: AppColors.textSecondary,
          ),
          child: Checkbox(
            value: value,
            activeColor: AppColors.secondary,
            checkColor: AppColors.textButton,
            onChanged: onChanged,
          ),
        ),
        Text(
          label ?? AppLocalizations.of(context)!.auth_remember_me,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
