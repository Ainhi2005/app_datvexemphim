// lib/features/movie/widgets/cast_item.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';

class CastItem extends StatelessWidget {
  final String name;
  final String? imageUrl; // Có thể để null nếu không có ảnh

  const CastItem({super.key, required this.name, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: imageUrl != null 
                ? NetworkImage(imageUrl!) 
                : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}