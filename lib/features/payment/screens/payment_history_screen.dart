import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../ticket/providers/ticket_provider.dart';
import '../../ticket/screens/my_ticket_screen.dart';
import '../providers/payment_provider.dart';
import '../widgets/qr_payment_dialog.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  late Future<List<dynamic>> _historyFuture;

  @override
  void initState() {
    super.initState();
    // Lấy danh sách bookings, mỗi booking tương đương với một phiên thanh toán/giao dịch
    _historyFuture = context.read<TicketProvider>().getMyTickets();
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
      case 'SUCCESS':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'CANCELLED':
      case 'FAILED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
      case 'SUCCESS':
        return 'Thành công';
      case 'PENDING':
        return 'Chờ thanh toán';
      case 'CANCELLED':
      case 'FAILED':
        return 'Đã huỷ';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Lịch sử thanh toán',
          style: AppTextStyles.titleLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.secondary));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Đã xảy ra lỗi: ${snapshot.error}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Bạn chưa có giao dịch nào',
                  style: TextStyle(color: Colors.white54)),
            );
          }

          final histories = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: histories.length,
            itemBuilder: (context, index) {
              return PaymentHistoryCard(baseItem: histories[index]);
            },
          );
        },
      ),
    );
  }
}

class PaymentHistoryCard extends StatefulWidget {
  final Map<String, dynamic> baseItem;

  const PaymentHistoryCard({super.key, required this.baseItem});

  @override
  State<PaymentHistoryCard> createState() => _PaymentHistoryCardState();
}

class _PaymentHistoryCardState extends State<PaymentHistoryCard> {
  Map<String, dynamic>? detailData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final int bookingId = widget.baseItem['id'];
      final data = await context.read<TicketProvider>().getTicketDetail(bookingId);
      if (mounted) {
        setState(() {
          detailData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
      case 'SUCCESS':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'CANCELLED':
      case 'FAILED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
      case 'SUCCESS':
        return 'Thành công';
      case 'PENDING':
        return 'Chờ thanh toán';
      case 'CANCELLED':
      case 'FAILED':
        return 'Đã huỷ';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemSource = detailData ?? widget.baseItem;
    final showtimeInfo = itemSource['showtime'] ?? {};
    final movieInfo = showtimeInfo['movie'] ?? {};

    final title = movieInfo['title'] ?? (isLoading ? "Đang tải dữ liệu..." : "Phim không xác định");
    final price = itemSource['totalPrice'] ?? 0;
    final status = itemSource['status'] ?? 'UNKNOWN';

    String dateStr = "N/A";
    if (itemSource['createdAt'] != null) {
      DateTime dt = DateTime.parse(itemSource['createdAt']).toLocal();
      dateStr = DateFormat('HH:mm - dd/MM/yyyy').format(dt);
    }

    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return GestureDetector(
      onTap: () async {
        final currentStatus = status.toUpperCase();
        if (currentStatus == 'SUCCESS' || currentStatus == 'CONFIRMED') {
          if (detailData != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MyTicketScreen(historyData: detailData),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Đang tải dữ liệu, vui lòng đợi..."),
                backgroundColor: Colors.orange,
              ),
            );
          }
        } else if (currentStatus == 'PENDING') {
          final provider = context.read<PaymentProvider>();
          final int bookingId = itemSource['id'];
          final double amount = (itemSource['totalPrice'] ?? 0).toDouble();
          
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.secondary)),
          );

          final newPaymentId = await provider.retryPayment(bookingId, "MOCK");
          
          if (context.mounted) {
            Navigator.pop(context); // close loading
            if (newPaymentId != null) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => QRPaymentDialog(
                  provider: provider,
                  paymentId: newPaymentId,
                  amount: amount,
                  initialSecondsLeft: 600, // Quay lại đếm đúng 10 phút mới
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(provider.errorMessage ?? "Có lỗi xảy ra, không thể thanh toán lại."),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } else if (currentStatus == 'CANCELLED' || currentStatus == 'FAILED') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Vé này đã được hủy"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getStatusColor(status).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                status.toUpperCase() == 'CONFIRMED' || status.toUpperCase() == 'SUCCESS' 
                    ? Icons.check_circle_outline 
                    : status.toUpperCase() == 'PENDING' 
                        ? Icons.access_time 
                        : Icons.cancel_outlined,
                color: _getStatusColor(status),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateStr,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currencyFormatter.format(price),
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getStatusText(status),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
