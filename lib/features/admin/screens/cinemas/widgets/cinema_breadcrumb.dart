import 'package:flutter/material.dart';

/// Thanh điều hướng breadcrumb: Rạp phim > [Tên rạp] > [Tên phòng]
class CinemaBreadcrumb extends StatelessWidget {
  final int currentViewIndex;
  final dynamic selectedCinema;
  final dynamic selectedRoom;
  final VoidCallback onGoToCinemas;
  final VoidCallback onGoToRooms;

  const CinemaBreadcrumb({
    super.key,
    required this.currentViewIndex,
    required this.selectedCinema,
    required this.selectedRoom,
    required this.onGoToCinemas,
    required this.onGoToRooms,
  });

  @override
  Widget build(BuildContext context) {
    if (currentViewIndex == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF141414),
      child: Row(
        children: [
          InkWell(
            onTap: onGoToCinemas,
            child: const Text(
              'Rạp phim',
              style: TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          if (currentViewIndex >= 1 && selectedCinema != null) ...[
            const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
            InkWell(
              onTap: currentViewIndex > 1 ? onGoToRooms : null,
              child: Text(
                selectedCinema['name'] ?? '',
                style: TextStyle(
                  color: currentViewIndex == 1 ? Colors.white : Colors.amber,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          if (currentViewIndex >= 2 && selectedRoom != null) ...[
            const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
            Text(
              selectedRoom['name'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
