import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AvatarPicker extends StatelessWidget {
  final String? localAvatarPath;
  final String? networkAvatarUrl;
  final VoidCallback onTap;

  const AvatarPicker({
    super.key,
    required this.localAvatarPath,
    required this.networkAvatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.surface,
              backgroundImage: localAvatarPath != null
                  ? FileImage(File(localAvatarPath!)) as ImageProvider
                  : (networkAvatarUrl != null ? NetworkImage(networkAvatarUrl!) : null),
              child: localAvatarPath == null && networkAvatarUrl == null
                  ? const Icon(Icons.person, size: 50, color: AppColors.textSecondary)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: AppColors.textButton, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
