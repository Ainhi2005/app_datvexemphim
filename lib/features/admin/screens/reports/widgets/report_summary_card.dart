import 'package:flutter/material.dart';

/// Card thống kê dạng dọc (icon + title + value)
class ReportSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool horizontal;

  const ReportSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.12), color.withValues(alpha: 0.02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: horizontal ? 12 : 14,
        horizontal: horizontal ? 16 : 10,
      ),
      child: horizontal ? _buildHorizontal() : _buildVertical(),
    );
  }

  Widget _iconContainer() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildVertical() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _iconContainer(),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildHorizontal() {
    return Row(
      children: [
        _iconContainer(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5)),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}
