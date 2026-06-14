import 'package:flutter/foundation.dart';
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

  Future<List<Seat>> getSeats(Showtime showtime) async {
    try {
      debugPrint('🔍 [START] Fetching seat map for Showtime ID: ${showtime.id}');
      
      final response = await _dio.get('/bookings/showtimes/${showtime.id}/seats');

      List<Seat> finalSeatsList = [];

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data;
        
        if (resData is Map && resData['success'] == true && resData['data'] != null) {
          final dataBlock = resData['data'];
          
          if (dataBlock is Map && dataBlock.containsKey('seatMap')) {
            final dynamic seatMapJson = dataBlock['seatMap'];
            
            if (seatMapJson is Map) {
              // Duyệt qua từng hàng ghế ("A", "B", "C"...) bên trong đối tượng seatMap
              seatMapJson.forEach((rowKey, seatsInRow) {
                if (seatsInRow is List) {
                  for (var seatJson in seatsInRow) {
                    final Map<String, dynamic> seatMapCast = Map<String, dynamic>.from(seatJson);
                    
                    // Ghế UNAVAILABLE (bị hỏng) sẽ không được thêm vào, hoặc thêm nhưng status là reserved
                    if (seatMapCast['status'] != 'UNAVAILABLE') {
                      final int seatId = seatMapCast['id'] ?? 0;
                      final String seatType = seatMapCast['type'] ?? 'NORMAL';
                      final double calculatedPrice = (seatMapCast['price'] ?? 0).toDouble();
                      final String label = seatMapCast['label'] ?? '';
                      
                      // Backend trả về status = OCCUPIED nếu ghế đã có người đặt
                      SeatStatus currentStatus = seatMapCast['status'] == 'OCCUPIED'
                          ? SeatStatus.reserved 
                          : SeatStatus.available;

                      final parsedSeat = Seat(
                        id: seatId,
                        roomId: showtime.roomId,
                        label: label,
                        type: seatType,
                        price: calculatedPrice,
                        status: currentStatus,
                      );
                      
                      finalSeatsList.add(parsedSeat);
                    }
                  }
                }
              });
            }
          }
        }
      }

      debugPrint('📊 Tổng số ghế hợp lệ bóc tách thành công để đưa lên UI: ${finalSeatsList.length} ghế.');
      return finalSeatsList;
      
    } catch (e) {
      debugPrint('❌ Lỗi xử lý bóc tách seatMap: $e');
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
      debugPrint('❌ Lỗi tạo dữ liệu đặt vé: $e');
      return false;
    }
  }
}
