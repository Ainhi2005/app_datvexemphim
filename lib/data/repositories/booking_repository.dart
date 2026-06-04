// lib/data/repositories/booking_repository.dart

import 'package:dio/dio.dart';
import '../models/seat.dart';
import '../../core/constants/api_constants.dart';
import '../models/showtime.dart';

class BookingRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  /// Lấy sơ đồ ghế đầy đủ kèm trạng thái đặt động
  /// Lấy sơ đồ ghế đầy đủ kèm trạng thái đặt động
  /// Lấy sơ đồ ghế đầy đủ từ cấu trúc seatMap của Backend
  Future<List<Seat>> getSeats(Showtime showtime) async {
    try {
      print('🔍 [START] Fetching seat map for Room ID: ${showtime.roomId}, Showtime ID: ${showtime.id}');
      
      // 1. Gọi API song song lấy thông tin sơ đồ ghế và vé đã bán
      final responses = await Future.wait([
        _dio.get('/rooms/${showtime.roomId}/seats'),
        _dio.get('/showtimes/${showtime.id}'),
      ]);

      List<int> reservedSeatIds = [];
      
      // 2. BÓC TÁCH GHẾ ĐÃ ĐẶT (Giữ nguyên luồng an toàn trước đó)
      if (responses[1].statusCode == 200 && responses[1].data != null) {
        final res1Data = responses[1].data;
        final showtimeDetail = res1Data is Map && res1Data.containsKey('data') ? res1Data['data'] : res1Data;

        if (showtimeDetail != null && showtimeDetail is Map) {
          var bSeatsData = showtimeDetail['booking_seats'] ?? showtimeDetail['bookingSeats'];
          if (bSeatsData is Map && bSeatsData.containsKey('data')) {
            bSeatsData = bSeatsData['data'];
          }
          if (bSeatsData is List) {
            reservedSeatIds = bSeatsData.map((bs) => (bs['seat_id'] ?? bs['seatId'] ?? 0) as int).toList();
            print('✅ Found ${reservedSeatIds.length} reserved seat IDs.');
          }
        }
      }

      // 3. BÓC TÁCH CẤU TRÚC "seatMap" ĐA TẦNG TỪ POSTMAN
      List<Seat> finalSeatsList = [];

      if (responses[0].statusCode == 200 && responses[0].data != null) {
        final res0Data = responses[0].data;
        
        if (res0Data is Map && res0Data['success'] == true && res0Data['data'] != null) {
          final dataBlock = res0Data['data'];
          
          if (dataBlock is Map && dataBlock.containsKey('seatMap')) {
            final dynamic seatMapJson = dataBlock['seatMap'];
            
            if (seatMapJson is Map) {
              final priceConfig = {
                'basePrice': showtime.basePrice,
                'vipPrice': showtime.vipPrice,
                'couplePrice': showtime.couplePrice,
              };

              // Duyệt qua từng hàng ghế ("A", "B", "C"...) bên trong đối tượng seatMap
              seatMapJson.forEach((rowKey, seatsInRow) {
                if (seatsInRow is List) {
                  for (var seatJson in seatsInRow) {
                    final Map<String, dynamic> seatMapCast = Map<String, dynamic>.from(seatJson);
                    
                    // 💡 ĐIỀU KIỆN LỌC CHÍ MẠNG: Chỉ lấy những ghế có isActive == true
                    if (seatMapCast['isActive'] == true) {
                      final Seat parsedSeat = Seat.fromJson(seatMapCast, priceConfig, reservedSeatIds);
                      finalSeatsList.add(parsedSeat);
                    }
                  }
                }
              });
            }
          }
        }
      }

      print('📊 Tổng số ghế hợp lệ bóc tách thành công để đưa lên UI: ${finalSeatsList.length} ghế.');
      return finalSeatsList;
      
    } catch (e) {
      print('❌ Lỗi xử lý bóc tách seatMap: $e');
      return [];
    }
  }

  /// Gửi dữ liệu đặt vé giữ chỗ lên Backend
  Future<bool> createBooking({
    required int showtimeId,
    required List<int> seatIds,
    List<int>? comboIds, // Nếu bạn có tính năng chọn bắp nước đi kèm
  }) async {
    try {
      final response = await _dio.post(
        '/bookings',
        data: {
          'showtimeId': showtimeId,
          'seatIds': seatIds,
          'combos': comboIds ?? [],
        },
      );

      return response.statusCode == 201 || (response.data['success'] == true);
    } catch (e) {
      print('❌ Lỗi tạo dữ liệu đặt vé: $e');
      return false;
    }
  }
}
