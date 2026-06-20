import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 💡 THÊM: Thư viện định dạng số và tiền tệ chuyên dụng
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../data/models/showtime.dart';
import '../../../data/models/seat.dart'; 
import '../../../data/repositories/booking_repository.dart'; 
import '../../../data/models/booking_selection.dart';
import '../../payment/screens/payment_screen.dart';

import '../widgets/screen_arc_indicator.dart';
import '../widgets/seat_matrix.dart';
import '../widgets/seat_status_legend.dart';
import '../widgets/ticket_price_table.dart';
import '../widgets/booking_bottom_bar.dart';
import 'package:tet/core/l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.booking_select_seat, style: AppTextStyles.headlineMedium),
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
                const ScreenArcIndicator(),
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
                        child: SeatMatrix(
                          seats: _seats,
                          selectedSeatIds: _selectedSeatIds,
                          onSeatTap: _handleSeatTap,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // 2. CHÚ THÍCH TRẠNG THÁI VẬT LÝ
                const SeatStatusLegend(),
                
                // 3. BẢNG PHÂN HẠNG GIÁ VÉ 2 CỘT (Đã format dấu chấm)
                TicketPriceTable(
                  showtime: _currentShowtime,
                  currencyFormatter: _currencyFormatter,
                ),
                
                Divider(color: AppColors.textPrimary.withValues(alpha: 0.1), height: 1), // Thay Colors.white10
                
                // 4. KHỐI TỔNG THANH TOÁN (Đã format dấu chấm)
                BookingBottomBar(
                  totalPrice: _totalPrice,
                  currencyFormatter: _currencyFormatter,
                  onSubmit: _selectedSeatIds.isEmpty ? null : () => _submitBookingData(_currentShowtime),
                ),
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

  void _submitBookingData(Showtime showtime) {
    if (_selectedSeatIds.isEmpty) return;

    // Lấy thông tin phim từ arguments hoặc từ showtime nếu có
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final movie = args['movie'] ?? args['movieDetail']; // Cần truyền movie vào args khi push route

    // Tìm các ghế đã chọn để lấy label
    List<String> selectedLabels = _seats
        .where((s) => _selectedSeatIds.contains(s.id))
        .map((s) => s.label)
        .toList();

    final selection = BookingSelection(
      movie: movie, // Giả định movie được truyền qua args
      showtimeId: showtime.id,
      cinemaName: args['cinemaName'] ?? 'Cinema Name', // Giả định cinemaName được truyền qua args
      roomName: showtime.roomName,
      selectedSeatIds: _selectedSeatIds.toList(),
      selectedSeatLabels: selectedLabels,
      seatPrice: showtime.basePrice,
      showtimeDate: showtime.startTime,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(selection: selection),
      ),
    );
  }
}