enum SeatStatus { available, reserved, selected }
enum SeatType { normal, vip, couple }

class Seat {
  final String id; // VD: "A1", "B5"
  final SeatType type;
  SeatStatus status;
  final double price;

  Seat({
    required this.id,
    this.type = SeatType.normal,
    this.status = SeatStatus.available,
    required this.price,
  });
}