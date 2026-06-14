import 'package:flutter/material.dart';

class SeatGridView extends StatelessWidget {
  final Map<String, List<dynamic>> seatMap;
  final void Function(dynamic seat) onSeatTap;

  const SeatGridView({
    super.key,
    required this.seatMap,
    required this.onSeatTap,
  });

  Color _seatColor(String type, bool isActive) {
    if (!isActive) return Colors.red.withValues(alpha: 0.3);
    if (type == 'VIP') return Colors.amber;
    if (type == 'COUPLE') return Colors.pinkAccent;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final sortedRows = seatMap.keys.toList()..sort();

    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          'MÀN HÌNH CHIẾU',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: sortedRows.map((rowKey) {
                    final seatsInRow = List<dynamic>.from(seatMap[rowKey] ?? []);
                    seatsInRow.sort((a, b) => (a['number'] ?? 0).compareTo(b['number'] ?? 0));

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            child: Text(
                              rowKey,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ...seatsInRow.map((seat) {
                            final String type = seat['type'] ?? 'NORMAL';
                            final bool isActive = seat['isActive'] ?? true;
                            final Color color = _seatColor(type, isActive);

                            return GestureDetector(
                              onTap: () => onSeatTap(seat),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isActive ? color.withValues(alpha: 0.15) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: color,
                                    width: isActive ? 1.5 : 1,
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      '${seat['number']}',
                                      style: TextStyle(
                                        color: isActive ? Colors.white : Colors.grey,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (!isActive)
                                      const Icon(Icons.close, size: 18, color: Colors.redAccent),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        // Chú giải màu ghế
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF121212),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('Thường', Colors.grey),
              _buildLegendItem('VIP', Colors.amber),
              _buildLegendItem('Couple', Colors.pinkAccent),
              _buildLegendItem('Hỏng/Khóa', Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color, width: 1.5),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
