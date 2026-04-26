import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class NowPlayingCard extends StatelessWidget {
  final String title;
  final String duration;
  final String genre;
  final double rating;
  final int reviewCount;
  final String imageUrl;

  const NowPlayingCard({
    super.key,
    required this.title,
    required this.duration,
    required this.genre,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh phim
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 280,
                color: AppColors.cardColor,
                child: const Icon(Icons.movie, size: 50, color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Tên phim
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Thời lượng và thể loại
          Row(
            children: [
              Text(
                duration,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const Text(
                ' · ',
                style: TextStyle(color: Colors.white70),
              ),
              Expanded(
                child: Text(
                  genre,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Rating
          Row(
            children: [
              const Icon(
                Icons.star,
                size: 16,
                color: Color(0xFFFFD700),
              ),
              const SizedBox(width: 6),
              Text(
                '$rating (${reviewCount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')})',
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}