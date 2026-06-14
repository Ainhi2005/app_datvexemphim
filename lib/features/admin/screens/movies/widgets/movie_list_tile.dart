import 'package:flutter/material.dart';
import 'package:tet/data/models/movie.dart';

class MovieListTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MovieListTile({
    super.key,
    required this.movie,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: movie.posterUrl.isNotEmpty
              ? Image.network(
                  movie.posterUrl,
                  width: 44,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.movie, color: Colors.grey, size: 44),
                )
              : const Icon(Icons.movie, color: Colors.grey, size: 44),
        ),
        title: Text(
          movie.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Thời lượng: ${movie.duration} phút',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.blueAccent), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
