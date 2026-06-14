import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/ticket_provider.dart';
import '../screens/my_ticket_screen.dart';
import '../widgets/ticket_icon_text.dart';

class TicketCardItem extends StatefulWidget {
  final Map<String, dynamic> baseTicket;

  const TicketCardItem({super.key, required this.baseTicket});

  @override
  State<TicketCardItem> createState() => _TicketCardItemState();
}

class _TicketCardItemState extends State<TicketCardItem> {
  Map<String, dynamic>? detailData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTicketDetail();
  }

  Future<void> _fetchTicketDetail() async {
    try {
      final int bookingId = widget.baseTicket['id'];
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: CircularProgressIndicator(color: Colors.white54)),
      );
    }

    final ticketSource = detailData ?? widget.baseTicket;
    final showtimeInfo = ticketSource['showtime'] ?? {};
    final movieInfo = showtimeInfo['movie'] ?? {};

    final String title = movieInfo['title'] ?? "Tên phim đang tải...";
    final String posterUrl = movieInfo['posterUrl'] ?? "";
    final String cinema = "Phòng chiếu ${showtimeInfo['roomId'] ?? ''}";

    String timeStr = "N/A";
    if (showtimeInfo['startTime'] != null) {
      DateTime dt = DateTime.parse(showtimeInfo['startTime']).toLocal();
      timeStr =
          "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} - ${dt.day}/${dt.month}/${dt.year}";
    }

    return GestureDetector(
      onTap: () {
        if (detailData != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MyTicketScreen(historyData: detailData),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                posterUrl.isNotEmpty ? posterUrl : 'https://picsum.photos/150',
                width: 80,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 120,
                  color: Colors.grey[800],
                  child: const Icon(Icons.movie, color: Colors.white54, size: 40),
                ),
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
                  const SizedBox(height: 12),
                  TicketIconText(
                    icon: Icons.access_time,
                    text: timeStr,
                    iconColor: Colors.grey,
                    textColor: Colors.grey,
                    iconSize: 16,
                  ),
                  const SizedBox(height: 8),
                  TicketIconText(
                    icon: Icons.location_on_outlined,
                    text: cinema,
                    iconColor: Colors.grey,
                    textColor: Colors.grey,
                    iconSize: 16,
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
