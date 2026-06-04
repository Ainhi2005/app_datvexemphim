// lib/features/movie/screens/select_seat_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 💡 THÊM: Thư viện định dạng số và tiền tệ chuyên dụng
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../data/models/showtime.dart';
import '../../../data/models/seat.dart'; 
import '../../../data/repositories/booking_repository.dart'; 

class SelectSeatScreen extends StatefulWidget {
  const SelectSeatScreen({super.key});

  @override
  State<SelectSeatScreen> createState() => _SelectSeatScreenState();
}

class _SelectSeatScreenState extends State<SelectSeatScreen> {
  final BookingRepository _bookingRepository = BookingRepository();
  
  // 💡 KHỞI TẠO: Bộ định dạng tiền tệ có dấu chấm phân cách hàng nghìn theo chuẩn Việt Nam
  final NumberFormat _currencyFormatter = NumberFormat('#,###', 'vi_VN');

  bool _isLoadingSeats = true;
  List<Seat> _seats = []; 
  final Set<int> _selectedSeatIds = <int>{}; 
  double _totalPrice = 0.0;
  late Showtime _currentShowtime;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _currentShowtime = args['showtime'] as Showtime;

    if (_isLoadingSeats && _seats.isEmpty) {
      _fetchSeatPlan(_currentShowtime);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Chọn Ghế", style: AppTextStyles.headlineMedium),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoadingSeats
          ? const Center(child: LoadingIndicator())
          : Column(
              children: [
                const SizedBox(height: 10),
                _buildScreenArcIndicator(),
                const SizedBox(height: 20),
                
                // 1. SƠ ĐỒ MA TRẬN GHẾ CUỘN ĐA HƯỚNG
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                        child: _buildDynamicSeatMatrix(),
                      ),
                    ),
                  ),
                ),
                
                // 2. CHÚ THÍCH TRẠNG THÁI VẬT LÝ
                _buildSeatStatusLegend(),
                
                // 3. BẢNG PHÂN HẠNG GIÁ VÉ 2 CỘT (Đã format dấu chấm)
                _buildTicketPriceTable(_currentShowtime),
                
                const Divider(color: Colors.white10, height: 1),
                
                // 4. KHỐI TỔNG THANH TOÁN (Đã format dấu chấm)
                _buildPriceAndBookingBottomSection(_currentShowtime),
              ],
            ),
    );
  }

  Future<void> _fetchSeatPlan(Showtime showtime) async {
    final List<Seat> fetchedSeats = await _bookingRepository.getSeats(showtime);
    setState(() {
      _seats = fetchedSeats;
      _isLoadingSeats = false;
    });
  }

  void _handleSeatTap(Seat seat) {
    if (seat.status == SeatStatus.reserved) return;

    final int id = seat.id; 
    final double price = seat.price;

    setState(() {
      if (_selectedSeatIds.contains(id)) {
        _selectedSeatIds.remove(id);
        _totalPrice -= price;
        seat.status = SeatStatus.available;
      } else {
        _selectedSeatIds.add(id);
        _totalPrice += price;
        seat.status = SeatStatus.selected;
      }
    });
  }

  Future<void> _submitBookingData(int showtimeId) async {
    setState(() => _isLoadingSeats = true);
    
    final success = await _bookingRepository.createBooking(
      showtimeId: showtimeId,
      seatIds: _selectedSeatIds.toList(),
    );

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
          content: Text("Lỗi hệ thống: Giữ ghế thất bại hoặc ghế đã có người đặt trước."),
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
          height: 4,
          width: MediaQuery.of(context).size.width * 0.65,
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.2),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "MÀN HÌNH CHIẾU",
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white24,
            fontSize: 9,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicSeatMatrix() {
    if (_seats.isEmpty) {
      return const Center(child: Text("Sơ đồ phòng chiếu đang trống"));
    }

    final Map<String, List<Seat>> rowGroupedSeats = {};
    for (var seat in _seats) {
      final String rowLetter = seat.label.isNotEmpty ? seat.label.substring(0, 1) : "A";
      rowGroupedSeats.putIfAbsent(rowLetter, () => []).add(seat);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rowGroupedSeats.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8), 
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: entry.value.map((seat) {
              return _buildIndividualSeatWidget(seat);
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIndividualSeatWidget(Seat seat) {
    final bool isReserved = seat.status == SeatStatus.reserved;
    final bool isSelected = seat.status == SeatStatus.selected;

    double seatWidth = 34;
    double seatHeight = 34;
    
    if (seat.type == 'COUPLE') {
      seatWidth = 76; 
    }

    Color boxColor = const Color(0xFF262A34); 
    Color borderColor = Colors.transparent;
    Color textColor = Colors.white54;

    if (seat.type == 'VIP' && !isReserved && !isSelected) {
      boxColor = const Color(0xFF3A301E); 
      borderColor = Colors.amber.withOpacity(0.4);
      textColor = Colors.amber[200]!;
    } else if (seat.type == 'COUPLE' && !isReserved && !isSelected) {
      boxColor = const Color(0xFF3A222E); 
      borderColor = Colors.pink.withOpacity(0.4);
      textColor = Colors.pink[200]!;
    }

    if (isReserved) {
      boxColor = Colors.white.withOpacity(0.04); 
      borderColor = Colors.transparent;
      textColor = Colors.white12;
    } else if (isSelected) {
      boxColor = AppColors.secondary; 
      borderColor = Colors.white;
      textColor = Colors.black;
    }

    return GestureDetector(
      onTap: () => _handleSeatTap(seat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: seatWidth,
        height: seatHeight,
        margin: const EdgeInsets.symmetric(horizontal: 4), 
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(seat.type == 'COUPLE' ? 10 : 6), 
          border: Border.all(color: borderColor, width: 1),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.4),
              blurRadius: 6,
              spreadRadius: 1,
            )
          ] : null,
        ),
        child: Center(
          child: Text(
            seat.label,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeatStatusLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendStatusItem("Có sẵn", const Color(0xFF262A34)),
          const SizedBox(width: 28),
          _legendStatusItem("Đã đặt", Colors.white.withOpacity(0.04)),
          const SizedBox(width: 28),
          _legendStatusItem("Đang chọn", AppColors.secondary, hasBorder: true),
        ],
      ),
    );
  }

  Widget _legendStatusItem(String title, Color color, {bool hasBorder = false}) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: hasBorder ? Border.all(color: Colors.white, width: 0.8) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// 💡 SỬA: Áp dụng bộ format `_currencyFormatter.format()` cho từng hạng ghế
  Widget _buildTicketPriceTable(Showtime showtime) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      color: Colors.black.withOpacity(0.15),
      child: Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          _buildTableRow(
            seatWidget: _buildMockSeatUI(width: 34, color: const Color(0xFF262A34)),
            typeName: "Ghế thường",
            priceText: "${_currencyFormatter.format(showtime.basePrice)} VND",
          ),
          _buildTableRow(
            seatWidget: _buildMockSeatUI(
              width: 34, 
              color: const Color(0xFF3A301E), 
              borderCol: Colors.amber.withOpacity(0.4),
            ),
            typeName: "Ghế VIP",
            priceText: "${_currencyFormatter.format(showtime.vipPrice)} VND",
            isVipText: true,
          ),
          _buildTableRow(
            seatWidget: _buildMockSeatUI(
              width: 76, 
              color: const Color(0xFF3A222E), 
              borderCol: Colors.pink.withOpacity(0.4),
              isCouple: true,
            ),
            typeName: "Ghế đôi (Couple)",
            priceText: "${_currencyFormatter.format(showtime.couplePrice)} VND",
            isCoupleText: true,
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow({
    required Widget seatWidget, 
    required String typeName, 
    required String priceText, // Nhận chuỗi đã format từ ngoài truyền vào
    bool isVipText = false,
    bool isCoupleText = false,
  }) {
    Color titleColor = AppColors.textPrimary;
    if (isVipText) titleColor = Colors.amber[200]!;
    if (isCoupleText) titleColor = Colors.pink[200]!;

    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: seatWidget,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                typeName,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                priceText, // Hiển thị chuỗi định dạng
                style: TextStyle(
                  color: AppColors.secondary.withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMockSeatUI({required double width, required Color color, Color? borderCol, bool isCouple = false}) {
    return Container(
      width: width,
      height: 30, 
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(isCouple ? 10 : 6),
        border: borderCol != null ? Border.all(color: borderCol, width: 1) : null,
      ),
      child: Center(
        child: Icon(
          isCouple ? Icons.people_outline : Icons.person_outline,
          size: 12,
          color: borderCol ?? Colors.white38,
        ),
      ),
    );
  }

  /// 💡 SỬA: Áp dụng bộ format `_currencyFormatter.format(_totalPrice)` cho tổng thanh toán dưới chân app
  Widget _buildPriceAndBookingBottomSection(Showtime showtime) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  "${_currencyFormatter.format(_totalPrice)} VND", // Định dạng dấu chấm thông minh động
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
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
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