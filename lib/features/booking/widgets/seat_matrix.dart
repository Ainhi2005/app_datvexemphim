import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/seat.dart';
import 'package:tet/core/l10n/app_localizations.dart';

class SeatMatrix extends StatelessWidget {
  final List<Seat> seats;
  final Set<int> selectedSeatIds;
  final ValueChanged<Seat> onSeatTap;

  const SeatMatrix({
    super.key,
    required this.seats,
    required this.selectedSeatIds,
    required this.onSeatTap,
  });

  @override
  Widget build(BuildContext context) {
    if (seats.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.booking_seat_map_empty));
    }

    final Map<String, List<Seat>> rowGroupedSeats = {};
    for (var seat in seats) {
      final String rowLetter = seat.label.isNotEmpty ? seat.label.substring(0, 1) : "A";
      rowGroupedSeats.putIfAbsent(rowLetter, () => []).add(seat);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rowGroupedSeats.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8), 
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: entry.value.map((seat) {
              return _buildIndividualSeatWidget(seat);
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIndividualSeatWidget(Seat seat) {
    final bool isReserved = seat.status == SeatStatus.reserved;
    final bool isSelected = selectedSeatIds.contains(seat.id) || seat.status == SeatStatus.selected;

    double seatWidth = 34;
    double seatHeight = 34;
    
    if (seat.type == 'COUPLE') {
      seatWidth = 76; 
    }

    Color boxColor = AppColors.surface; // Thay Color(0xFF262A34)
    Color borderColor = Colors.transparent;
    Color textColor = AppColors.textSecondary; // Thay Colors.white54

    if (seat.type == 'VIP' && !isReserved && !isSelected) {
      boxColor = const Color(0xFF3A301E); 
      borderColor = Colors.amber.withValues(alpha: 0.4);
      textColor = Colors.amber[200]!;
    } else if (seat.type == 'COUPLE' && !isReserved && !isSelected) {
      boxColor = const Color(0xFF3A222E); 
      borderColor = Colors.pink.withValues(alpha: 0.4);
      textColor = Colors.pink[200]!;
    }

    if (isReserved) {
      boxColor = AppColors.textPrimary.withValues(alpha: 0.04); 
      borderColor = Colors.transparent;
      textColor = AppColors.textPrimary.withValues(alpha: 0.12);
    } else if (isSelected) {
      boxColor = AppColors.secondary; 
      borderColor = Colors.white;
      textColor = Colors.black; // Text on secondary color is black
    }

    return GestureDetector(
      onTap: () => onSeatTap(seat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: seatWidth,
        height: seatHeight,
        margin: const EdgeInsets.symmetric(horizontal: 4), 
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(seat.type == 'COUPLE' ? 10 : 6), 
          border: Border.all(color: borderColor, width: 1),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.4),
              blurRadius: 6,
              spreadRadius: 1,
            )
          ] : null,
        ),
        child: Center(
          child: Text(
            seat.label,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
