// lib/data/models/seat.dart

enum SeatStatus { available, reserved, selected }

class Seat {
  final int id;         // id dạng số tăng tự động trong bảng seats dưới DB
  final int roomId;
  final String label;   // Tên ghế (VD: "A1", "B5")
  final String type;    // Loại ghế: "NORMAL", "VIP", "COUPLE"
  final double price;   // Giá tiền tính toán động
  SeatStatus status;    // Trạng thái hiển thị trên giao diện App

  Seat({
    required this.id,
    required this.roomId,
    required this.label,
    required this.type,
    required this.price,
    this.status = SeatStatus.available,
  });

  factory Seat.fromJson(Map<String, dynamic> json, Map<String, dynamic> priceConfig, List<int> reservedSeatIds) {
    final int seatId = json['id'] ?? 0;
    final String seatType = json['type'] ?? 'NORMAL';
    
    // Thuật toán ánh xạ tính giá tiền thông minh từ cấu hình giá của Suất chiếu (Showtime)
    double calculatedPrice = (priceConfig['basePrice'] ?? 0).toDouble();
    if (seatType == 'VIP') {
      calculatedPrice = (priceConfig['vipPrice'] ?? 0).toDouble();
    } else if (seatType == 'COUPLE') {
      calculatedPrice = (priceConfig['couplePrice'] ?? 0).toDouble();
    }

    // Kiểm tra chéo xem ID ghế này đã nằm trong mảng ghế bị đặt trước đó chưa
    SeatStatus currentStatus = reservedSeatIds.contains(seatId) 
        ? SeatStatus.reserved 
        : SeatStatus.available;

    return Seat(
      id: seatId,
      roomId: json['room_id'] ?? json['roomId'] ?? 0,
      label: json['label'] ?? json['seat_label'] ?? '',
      type: seatType,
      price: calculatedPrice,
      status: currentStatus,
    );
  }
}