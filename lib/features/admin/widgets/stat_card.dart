import 'package:flutter/material.dart';

/// Card thống kê nhanh trên Dashboard (doanh thu, vé, phim)
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final bool isFullWidth;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: isFullWidth
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 8),
                Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
    );
  }
}
