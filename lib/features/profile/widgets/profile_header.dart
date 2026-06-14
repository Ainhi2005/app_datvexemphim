import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/user_model.dart';
import '../screens/edit_profile_screen.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel? user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.surface,
          backgroundImage: user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
          child: user?.avatarUrl == null
              ? const Icon(Icons.person, size: 40, color: AppColors.textSecondary)
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(user?.name ?? 'Tên người dùng', style: AppTextStyles.headlineMedium),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone_outlined, color: AppColors.textSecondary, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    user?.phone ?? 'Chưa cập nhật SĐT',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.email_outlined, color: AppColors.textSecondary, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    user?.email ?? 'Chưa cập nhật Email',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
