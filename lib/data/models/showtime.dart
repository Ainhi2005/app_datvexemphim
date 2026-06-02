import 'cinema.dart';

class BackendShowtime {
  final int id;
  final int movieId;
  final int roomId;
  final DateTime startTime;
  final double basePrice;
  final double vipPrice;
  final double couplePrice;
  final Cinema? cinema; // Thường được lồng kèm trong API chi tiết suất chiếu

  BackendShowtime({
    required this.id,
    required this.movieId,
    required this.roomId,
    required this.startTime,
    required this.basePrice,
    required this.vipPrice,
    required this.couplePrice,
    this.cinema,
  });

 factory BackendShowtime.fromJson(Map<String, dynamic> json) {
  Cinema? associatedCinema;

  // 💡 QUÉT ĐA TẦNG: Chấp nhận tất cả các kiểu trả về của Backend để không bị sót
  if (json['room'] != null) {
    var roomJson = json['room'];
    if (roomJson['cinema'] != null) {
      associatedCinema = Cinema.fromJson(roomJson['cinema'] as Map<String, dynamic>);
    } else if (roomJson['Cinema'] != null) {
      associatedCinema = Cinema.fromJson(roomJson['Cinema'] as Map<String, dynamic>);
    }
  } else if (json['Room'] != null) { // Trường hợp Backend trả về chữ R viết hoa
    var roomJson = json['Room'];
    if (roomJson['Cinema'] != null) {
      associatedCinema = Cinema.fromJson(roomJson['Cinema'] as Map<String, dynamic>);
    } else if (roomJson['cinema'] != null) {
      associatedCinema = Cinema.fromJson(roomJson['cinema'] as Map<String, dynamic>);
    }
  }

  // Khôi phục các đoạn gán trường khác bên dưới của bạn...
  return BackendShowtime(
    id: json['id'] ?? 0,
    movieId: json['movie_id'] ?? json['movieId'] ?? 0,
    roomId: json['room_id'] ?? json['roomId'] ?? 0,
    startTime: DateTime.parse(json['start_time'] ?? json['startTime']),
    basePrice: (json['base_price'] ?? json['basePrice'] ?? 0).toDouble(),
    vipPrice: (json['vip_price'] ?? json['vipPrice'] ?? 0).toDouble(),
    couplePrice: (json['couple_price'] ?? json['couplePrice'] ?? 0).toDouble(),
    cinema: associatedCinema, // Gán đối tượng rạp đã bóc tách an toàn
  );
}
}