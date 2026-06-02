// lib/data/repositories/booking_repository.dart

import '../models/seat.dart';
import '../services/booking_api_service.dart';

class BookingRepository {
  final BookingApiService _apiService = BookingApiService();

  Future<List<Seat>> getSeats(int roomId) async {
    try {
      final response = await _apiService.getSeatsByRoom(roomId);
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        List<Seat> flattenSeatsList = [];

        // 💡 KHỚP 100% VỚI JSON MỚI: Bóc trích object 'data' -> 'seatMap'
        if (responseData != null && responseData['success'] == true) {
          final dataObject = responseData['data'];
          if (dataObject != null && dataObject['seatMap'] is Map) {
            final Map<String, dynamic> seatMap = dataObject['seatMap'];

            // Duyệt qua từng hàng ghế ("A", "B", "C", "D"...)
            seatMap.forEach((rowName, seatsInRow) {
              if (seatsInRow is List) {
                for (var element in seatsInRow) {
                  final seatJson = element as Map<String, dynamic>;
                  
                  // Lấy mã nhãn ghế (Ví dụ: "A1", "B10")
                  final String seatLabel = seatJson['label'] ?? '';

                  // Kiểm tra xem ghế có hoạt động và có bị khóa hay không
                  // JSON hiện tại chưa có trường isReserved, ta phòng vệ qua trạng thái isActive
                  final bool isSeatActive = seatJson['isActive'] ?? true;

                  flattenSeatsList.add(
                    Seat(
                      id: seatLabel, // Khớp với String id của Model bạn
                      // Ép kiểu giá tiền an toàn (Nếu JSON BE thiếu trường price, lấy giá mặc định 80000 VND)
                      price: (seatJson['price'] ?? 80000 as num).toDouble(),
                      status: !isSeatActive 
                          ? SeatStatus.reserved 
                          : SeatStatus.available,
                      type: _mapType(seatJson['type'] ?? 'NORMAL'),
                    ),
                  );
                }
              }
            });
          }
        }
        
        print("🎯 [Repo] Đã bóc tách thành công ${flattenSeatsList.length} ghế về danh sách phẳng.");
        return flattenSeatsList;
      }
    } catch (e) {
      print("❌ [BookingRepository Error] Lỗi bóc tách cấu trúc seatMap: $e");
    }
    return [];
  }

  SeatType _mapType(String type) {
    final upperType = type.toUpperCase();
    if (upperType == 'VIP') return SeatType.vip;
    if (upperType == 'COUPLE') return SeatType.couple;
    return SeatType.normal;
  }
}