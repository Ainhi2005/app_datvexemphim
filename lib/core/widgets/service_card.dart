import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class ServiceCard extends StatelessWidget {
  final String label;
  final String description;
  final String imageUrl;  // Đổi từ icon sang imageUrl

  const ServiceCard({
    super.key,
    required this.label,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            shape: BoxShape.circle, // 👈 dùng cái này thay vì borderRadius
            border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
          ),
          child: ClipOval(
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover, // 👈 giữ cái này
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.image, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.titleMedium.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}