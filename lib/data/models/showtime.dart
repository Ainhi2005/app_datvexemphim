// lib/data/models/showtime.dart
import 'package:intl/intl.dart';

class Showtime {
  final int id;
  final int movieId;
  final int roomId;
  final DateTime startTime;
  final DateTime endTime;
  final double basePrice;
  final double vipPrice;
  final double couplePrice;
  final String status;
  final String roomName;     
  final String cinemaName;   

  Showtime({
    required this.id,
    required this.movieId,
    required this.roomId,
    required this.startTime,
    required this.endTime,
    required this.basePrice,
    required this.vipPrice,
    required this.couplePrice,
    required this.status,
    required this.roomName,
    required this.cinemaName,
  });

  factory Showtime.fromJson(Map<String, dynamic> json) {
    final startStr = json['startTime'] ?? json['start_time'] ?? '';
    final endStr = json['endTime'] ?? json['end_time'] ?? '';
    
    // 1. Bóc tách khối thông tin Phòng chiếu (Room)
    final roomBlock = json['room'] is Map ? json['room'] : null;
    final String extractedRoomName = roomBlock != null 
        ? (roomBlock['name'] ?? 'Phòng chiếu') 
        : 'Phòng chiếu';

    // 2. KHÔI PHỤC: Bộ lọc bóc tách tên rạp đa tầng từ Object lồng nhau
    final cinemaBlock = json['cinema'] is Map ? json['cinema'] : null;
    String extractedCinemaName = 'Rạp MBooking'; 

    if (cinemaBlock != null) {
      // Bóc từ "cinema": {"name": "CGV Vincom Center"}
      extractedCinemaName = cinemaBlock['name'] ?? 'Rạp MBooking';
    } else if (json['cinemaName'] != null) {
      extractedCinemaName = json['cinemaName'];
    } else if (json['cinema_name'] != null) {
      extractedCinemaName = json['cinema_name'];
    } else if (json['cinemaId'] != null || json['cinema_id'] != null) {
      final int cId = json['cinemaId'] ?? json['cinema_id'] ?? 1;
      extractedCinemaName = 'Rạp Đối Tác (ID: $cId)';
    }

    return Showtime(
      id: json['id'] ?? 0,
      movieId: json['movieId'] ?? json['movie_id'] ?? 0,
      roomId: json['roomId'] ?? json['room_id'] ?? 0,
      startTime: startStr.isNotEmpty ? DateTime.parse(startStr).toLocal() : DateTime.now(),
      endTime: endStr.isNotEmpty ? DateTime.parse(endStr).toLocal() : DateTime.now(),
      basePrice: (json['basePrice'] ?? json['base_price'] ?? 0).toDouble(),
      vipPrice: (json['vipPrice'] ?? json['vip_price'] ?? 0).toDouble(),
      couplePrice: (json['couplePrice'] ?? json['couple_price'] ?? 0).toDouble(),
      status: json['status'] ?? 'ACTIVE',
      roomName: extractedRoomName,
      cinemaName: extractedCinemaName, 
    );
  }

  String get formattedTime => DateFormat('HH:mm').format(startTime);
  String get formattedDate => DateFormat('dd/MM/yyyy').format(startTime);

  // Thêm hàm này vào cuối class Showtime trước dấu đóng ngoặc nhọn }
  Showtime copyWith({
    int? id,
    int? movieId,
    int? roomId,
    DateTime? startTime,
    DateTime? endTime,
    double? basePrice,
    double? vipPrice,
    double? couplePrice,
    String? status,
    String? roomName,
    String? cinemaName,
  }) {
    return Showtime(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      roomId: roomId ?? this.roomId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      basePrice: basePrice ?? this.basePrice,
      vipPrice: vipPrice ?? this.vipPrice,
      couplePrice: couplePrice ?? this.couplePrice,
      status: status ?? this.status,
      roomName: roomName ?? this.roomName,
      cinemaName: cinemaName ?? this.cinemaName,
    );
  }
}