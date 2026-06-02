// lib/features/movie/providers/movie_detail_provider.dart

import 'package:flutter/material.dart';
import '../../../data/models/showtime.dart';
import '../../../data/services/cinema_api_service.dart';

class MovieDetailProvider extends ChangeNotifier {
  final CinemaApiService _apiService = CinemaApiService();

  bool isLoading = false;
  List<BackendShowtime> allShowtimes = [];

  // Trạng thái người dùng chọn trên UI
  DateTime? selectedDate;
  String? selectedCinemaName;
  BackendShowtime? selectedShowtime;

  Future<void> loadShowtimes(int movieId) async {
    isLoading = true;
    notifyListeners();

    try {
      // 1. Gọi dịch vụ API lấy dữ liệu thô từ backend
      final data = await _apiService.getShowtimesByMovie(movieId);

      print("🔍 DỮ LIỆU THÔ TỪ BACKEND TRẢ VỀ: $data");

      // 2. Chuyển đổi an toàn sang danh sách Model Object
      allShowtimes = data.map((json) {
        return BackendShowtime.fromJson(json as Map<String, dynamic>);
      }).toList();

      // 3. Sắp xếp thứ tự suất chiếu từ sáng đến tối để UI hiển thị đẹp mắt hơn
      allShowtimes.sort((a, b) => a.startTime.compareTo(b.startTime));

      // 4. LOGIC TỰ ĐỘNG CHỌN NGÀY MẶC ĐỊNH SAU KHI FETCH DATA THÀNH CÔNG
      if (allShowtimes.isNotEmpty) {
        final firstShowtimeDate = allShowtimes.first.startTime.toLocal();
        // Chỉ giữ lại Ngày - Tháng - Năm, đưa giờ phút giây về 0 để so sánh chuẩn xác
        selectedDate = DateTime(
          firstShowtimeDate.year,
          firstShowtimeDate.month,
          firstShowtimeDate.day,
        );
      } else {
        // Nếu bộ phim hoàn toàn chưa có suất chiếu nào dưới DB backend
        final now = DateTime.now();
        selectedDate = DateTime(now.year, now.month, now.day);
      }

      // Reset lại trạng thái rạp và giờ chiếu cũ tránh lưu đè dữ liệu của phim trước
      selectedCinemaName = null;
      selectedShowtime = null;
    } catch (e) {
      // Bẫy lỗi log ra màn hình debug nếu backend trả dữ liệu sai cấu trúc model
      print("❌ LỖI TẠI MOVIE_DETAIL_PROVIDER (loadShowtimes): $e");
      allShowtimes = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectDate(DateTime date) {
    // CHUẨN HÓA: Đưa ngày người dùng click chọn về Local Time và triệt tiêu giờ phút giây
    final localDate = date.toLocal();
    selectedDate = DateTime(localDate.year, localDate.month, localDate.day);

    print("📅 Người dùng chọn ngày: $selectedDate");

    // Đổi ngày thì bắt buộc phải xóa lựa chọn rạp và giờ cũ
    selectedCinemaName = null;
    selectedShowtime = null;
    notifyListeners();
  }

  void selectCinema(String cinemaName) {
    if (selectedCinemaName == cinemaName) {
      // Nếu người dùng click vào rạp đang mở -> Tự động thu gọn đóng danh sách giờ lại
      selectedCinemaName = null;
      print("🔽 Đóng rạp: $cinemaName");
    } else {
      selectedCinemaName = cinemaName;
      print("🔼 Mở rạp: $cinemaName");
    }
    // Đổi rạp thì reset giờ chiếu đang chọn
    selectedShowtime = null;
    notifyListeners();
  }

  void selectShowtime(BackendShowtime showtime) {
    selectedShowtime = showtime;
    notifyListeners();
  }
}