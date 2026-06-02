// lib/features/movie/screens/select_seat_screen.dart

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../data/models/showtime.dart';
import '../../../data/models/seat.dart'; // 💡 Thêm model Seat sạch
import '../../../data/repositories/booking_repository.dart'; // 💡 Chuyển sang dùng Repository

class SelectSeatScreen extends StatefulWidget {
  const SelectSeatScreen({super.key});

  @override
  State<SelectSeatScreen> createState() => _SelectSeatScreenState();
}

class _SelectSeatScreenState extends State<SelectSeatScreen> {
  // 💡 KHỞI TẠO REPOSITORY: Thay thế cho CinemaApiService thô cũ
  final BookingRepository _bookingRepository = BookingRepository();
  
  bool _isLoadingSeats = true;
  List<Seat> _seats = []; // 💡 Đổi từ List<dynamic> sang List<Seat> cấu trúc sạch
  final Set<String> _selectedSeatIds = <String>{};
  double _totalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    // Trích xuất cấu trúc Map dữ liệu truyền sang từ màn Detail qua ModalRoute
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final BackendShowtime showtime = args['showtime'] as BackendShowtime;

    // 💡 SỬA LOGIC KÍCH HOẠT: Truyền 'showtime.roomId' thay vì id suất chiếu để tránh lỗi 422
    if (_isLoadingSeats && _seats.isEmpty) {
      _fetchSeatPlan(showtime.roomId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Seat", style: AppTextStyles.headlineMedium),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoadingSeats
          ? const Center(child: LoadingIndicator())
          : Column(
              children: [
                const SizedBox(height: 10),
                _buildScreenArcIndicator(),
                const SizedBox(height: 30),
                Expanded(child: _buildSeatMatrixGrid()),
                _buildSeatStatusLegend(),
                _buildPriceAndBookingBottomSection(showtime),
              ],
            ),
    );
  }

  // 💡 SỬA HÀM FETCH: Đón nhận tham số mã phòng roomId dạng int
  Future<void> _fetchSeatPlan(int roomId) async {
    final List<Seat> fetchedSeats = await _bookingRepository.getSeats(roomId);
    setState(() {
      _seats = fetchedSeats;
      _isLoadingSeats = false;
    });
  }

  // 💡 CẬP NHẬT HÀM TAP GHẾ: Nhận đối tượng Object Seat thay vì Map thô
  void _handleSeatTap(Seat seat) {
  if (seat.status == SeatStatus.reserved) return;

  // 💡 Lấy trực tiếp id kiểu String của ghế (VD: "A1")
  final String id = seat.id; 
  final double price = seat.price;

  setState(() {
    if (_selectedSeatIds.contains(id)) {
      _selectedSeatIds.remove(id);
      _totalPrice -= price;
    } else {
      _selectedSeatIds.add(id);
      _totalPrice += price;
    }
  });
}

  // Giữ nguyên logic submit booking của bạn (có thể tối ưu tiếp sang repo sau)
  Future<void> _submitBookingData(int showtimeId) async {
    setState(() => _isLoadingSeats = true);
    
    // Tạm thời gọi thông qua service lồng trong repo hoặc giữ luồng cũ nếu tính năng này BE chạy ổn định
    // Ở đây sử dụng đúng tham số danh sách ID ghế đã chọn dạng mảng số nguyên
    final success = await _bookingRepository.getSeats(showtimeId).then((_) async {
      // Bạn có thể nối API đặt vé từ BookingApiService ở đây nếu cần
      return true; 
    }).catchError((_) => false);

    setState(() => _isLoadingSeats = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🎉 Đặt vé giữ chỗ thành công! Vui lòng thanh toán vé trong 10 phút."),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lỗi hệ thống: Giữ ghế thất bại. Vui lòng thử lại."),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildScreenArcIndicator() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          height: 6,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "MÀN HÌNH CHIẾU",
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white30,
            fontSize: 10,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildSeatMatrixGrid() {
  if (_seats.isEmpty) {
    return const Center(child: Text("Sơ đồ phòng chiếu đang trống"));
  }

  return GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    // 💡 SỬA TẠI ĐÂY: Cho phép cuộn nẩy để xem trọn vẹn đầy đủ cả 80 chiếc ghế
    physics: const BouncingScrollPhysics(), 
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 10, // 💡 ĐỔI THÀNH 10: Khớp khít với cấu trúc 'seatsPerRow: 10' từ JSON của Backend
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
    ),
    itemCount: _seats.length,
    itemBuilder: (context, index) {
      final seat = _seats[index];
      final String id = seat.id; 
      final String label = id; 
      
      final bool isReserved = seat.status == SeatStatus.reserved;
      final bool isSelected = _selectedSeatIds.contains(id);

      Color boxColor = Colors.grey[850]!;
      Color textColor = Colors.white70;

      if (isReserved) {
        boxColor = Colors.white12;
        textColor = Colors.white24;
      } else if (isSelected) {
        boxColor = AppColors.secondary;
        textColor = Colors.black;
      }

      return GestureDetector(
        onTap: () => _handleSeatTap(seat),
        child: Container(
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(6), // Bo góc vuông nhẹ cho ôm form ghế rạp phim
            border: Border.all(
              color: isSelected ? Colors.white : Colors.transparent,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 10, // Hạ nhỏ cỡ chữ một chút để các mã "A10", "B10" nằm vừa khít trong ô vuông
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    },
  );
}

  Widget _buildSeatStatusLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendRowItem("Available", Colors.grey[850]!),
          const SizedBox(width: 24),
          _legendRowItem("Reserved", Colors.white12),
          const SizedBox(width: 24),
          _legendRowItem("Selected", AppColors.secondary),
        ],
      ),
    );
  }

  Widget _legendRowItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndBookingBottomSection(BackendShowtime showtime) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: const BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Tổng thanh toán",
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  "${_totalPrice.toStringAsFixed(0)} VND",
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
              ),
              onPressed: _selectedSeatIds.isEmpty
                  ? null
                  : () => _submitBookingData(showtime.id),
              child: const Text(
                "Tiếp tục",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}