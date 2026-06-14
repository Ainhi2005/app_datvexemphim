import 'package:flutter/material.dart';

class ComboListTile extends StatelessWidget {
  final dynamic combo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ComboListTile({
    super.key,
    required this.combo,
    required this.onEdit,
    required this.onDelete,
  });

  static bool isActive(dynamic combo) {
    return combo['isActive'] == true ||
        combo['isActive'] == 1 ||
        combo['is_active'] == true ||
        combo['is_active'] == 1;
  }

  @override
  Widget build(BuildContext context) {
    final double price = (combo['price'] ?? 0.0).toDouble();
    final bool active = isActive(combo);
    final String? imageUrl = combo['imageUrl'] ?? combo['image_url'];
    final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: active
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.redAccent.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: hasImage
              ? Image.network(
                  imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(),
                )
              : _placeholder(),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                combo['name'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (!active)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Tạm dừng',
                  style: TextStyle(color: Colors.redAccent, fontSize: 10),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              combo['description'] ?? 'Không có mô tả',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              '${price.toStringAsFixed(0)} đ',
              style: const TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: onDelete),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 48,
      height: 48,
      color: Colors.amber.withValues(alpha: 0.1),
      child: const Icon(Icons.fastfood, color: Colors.amber, size: 24),
    );
  }
}
