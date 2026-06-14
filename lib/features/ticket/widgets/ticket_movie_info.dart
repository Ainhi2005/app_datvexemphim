import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';
import 'ticket_icon_text.dart';

class TicketMovieInfo extends StatelessWidget {
  final String posterUrl;
  final String movieTitle;
  final String genres;

  const TicketMovieInfo({
    super.key,
    required this.posterUrl,
    required this.movieTitle,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            posterUrl.isNotEmpty ? posterUrl : 'https://picsum.photos/150',
            width: 80,
            height: 110,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              width: 80,
              height: 110,
              color: Colors.grey[300],
              child: const Icon(Icons.movie, color: Colors.grey, size: 30),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movieTitle,
                style: AppTextStyles.titleLarge.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              TicketIconText(icon: Icons.access_time, text: "Thông tin thời lượng"),
              const SizedBox(height: 4),
              TicketIconText(icon: Icons.movie_creation_outlined, text: genres),
            ],
          ),
        ),
      ],
    );
  }
}
