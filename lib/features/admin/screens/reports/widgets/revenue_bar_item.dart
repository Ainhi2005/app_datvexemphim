import 'package:flutter/material.dart';

/// Card hiển thị một mục doanh thu theo phim hoặc rạp (có progress bar)
class RevenueBarItem extends StatelessWidget {
  final String label;
  final double revenue;
  final double ratio;
  final Color barColor;

  const RevenueBarItem({
    super.key,
    required this.label,
    required this.revenue,
    required this.ratio,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.1),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${revenue.toStringAsFixed(0)} đ',
                  style: TextStyle(color: barColor, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${(ratio * 100).toStringAsFixed(1)}%',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: ratio,
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
