import 'package:flutter/material.dart';

class CinemaListTile extends StatelessWidget {
  final dynamic cinema;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CinemaListTile({
    super.key,
    required this.cinema,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = cinema['imageUrl'] ?? cinema['image_url'];
    final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: hasImage
              ? Image.network(
                  imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholder(),
                )
              : _buildPlaceholder(),
        ),
        title: Text(
          cinema['name'] ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${cinema['address'] ?? ''}, ${cinema['city'] ?? ''}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13),
            ),
            if (cinema['phone'] != null && cinema['phone'].toString().isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                'SĐT: ${cinema['phone']}',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      color: Colors.amber.withValues(alpha: 0.1),
      child: const Icon(Icons.business, color: Colors.amber, size: 24),
    );
  }
}
