// lib/data/models/booking_selection.dart
import 'movie.dart';

class BookingSelection {
  final Movie movie;
  final int showtimeId;
  final String cinemaName;
  final String roomName;             // 💡 THÊM BIẾN NÀY ĐỂ CHỨA TÊN PHÒNG
  final List<int> selectedSeatIds;
  final List<String> selectedSeatLabels;
  final double seatPrice;
  final DateTime? showtimeDate;

  BookingSelection({
    required this.movie,
    required this.showtimeId,
    required this.cinemaName,
    required this.roomName,          // 💡 THÊM VÀO CONSTRUCTOR
    required this.selectedSeatIds,
    required this.selectedSeatLabels,
    required this.seatPrice,
    this.showtimeDate,
  });
}