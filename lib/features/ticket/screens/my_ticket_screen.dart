// lib/features/ticket/screens/my_ticket_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../payment/providers/payment_provider.dart';
import '../widgets/ticket_clipper.dart';
import '../widgets/ticket_movie_info.dart';
import '../widgets/ticket_date_row.dart';
import '../widgets/ticket_info_row.dart';
import '../widgets/ticket_dashed_line.dart';
import '../widgets/ticket_dashed_line.dart';
import '../widgets/ticket_qr_section.dart';
import 'package:tet/core/l10n/app_localizations.dart';

class MyTicketScreen extends StatelessWidget {
  final Map<String, dynamic>? historyData;

  const MyTicketScreen({super.key, this.historyData});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentProvider>(context, listen: false);
    final bool isHistory = historyData != null;

    if (!isHistory && provider.selection == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(AppLocalizations.of(context)!.ticket_no_data, style: const TextStyle(color: Colors.white)),
        ),
      );
    }

    final Map<String, dynamic> showtimeInfo =
        isHistory && historyData!['showtime'] != null ? historyData!['showtime'] : {};
    final Map<String, dynamic> movieInfo = showtimeInfo['movie'] ?? {};

    final String movieTitle =
        isHistory ? (movieInfo['title'] ?? AppLocalizations.of(context)!.ticket_movie_title) : provider.selection!.movie.title;
    final String posterUrl =
        isHistory ? (movieInfo['posterUrl'] ?? "") : provider.selection!.movie.posterUrl;

    String genresStr = "";
    if (isHistory && movieInfo['genres'] != null) {
      genresStr = (movieInfo['genres'] as List).join(', ');
    } else if (!isHistory) {
      genresStr = provider.selection!.movie.formattedGenres;
    }

    final String roomNameText =
        isHistory ? ("${AppLocalizations.of(context)!.ticket_room}${showtimeInfo['roomId'] ?? ''}") : provider.selection!.roomName;

    final String cinemaNameText = isHistory
        ? (showtimeInfo['cinema']?['name'] ?? AppLocalizations.of(context)!.ticket_cinema_system)
        : provider.selection!.cinemaName;

    final String orderId =
        isHistory ? historyData!['id'].toString() : (provider.confirmedOrderId ?? AppLocalizations.of(context)!.ticket_processing);

    final double totalPrice = isHistory
        ? double.tryParse(historyData!['totalPrice']?.toString() ?? '0') ?? 0.0
        : provider.totalPrice;

    String seatsLabel = "";
    if (isHistory && historyData!['seats'] != null) {
      final List seatsList = historyData!['seats'];
      seatsLabel = seatsList.map((s) => s['seatLabel']).join(', ');
    } else if (!isHistory) {
      seatsLabel = provider.selection!.selectedSeatLabels.join(', ');
    }

    String comboText = AppLocalizations.of(context)!.ticket_no_combo;
    if (isHistory &&
        historyData!['combos'] != null &&
        (historyData!['combos'] as List).isNotEmpty) {
      final List combosList = historyData!['combos'];
      comboText = combosList.map((c) => "${c['quantity']}x ${c['comboName']}").join(', ');
    } else if (!isHistory) {
      final selectedCombos = provider.availableCombos.where((c) => c.quantity > 0).toList();
      if (selectedCombos.isNotEmpty) {
        comboText = selectedCombos.map((c) => "${c.quantity}x ${c.name}").join(', ');
      }
    }

    String dateStr = AppLocalizations.of(context)!.ticket_updating;
    String timeStr = "N/A";
    if (isHistory && showtimeInfo['startTime'] != null) {
      DateTime dt = DateTime.parse(showtimeInfo['startTime']).toLocal();
      dateStr =
          "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}";
      timeStr = "${dt.hour.toString().padLeft(2, '0')}h${dt.minute.toString().padLeft(2, '0')}'";
    } else if (!isHistory && provider.showTimeDate != null) {
      dateStr =
          "${provider.showTimeDate!.day.toString().padLeft(2, '0')}.${provider.showTimeDate!.month.toString().padLeft(2, '0')}.${provider.showTimeDate!.year}";
      timeStr =
          "${provider.showTimeDate!.hour.toString().padLeft(2, '0')}h${provider.showTimeDate!.minute.toString().padLeft(2, '0')}'";
    }

    return PopScope(
      canPop: isHistory,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        if (!isHistory) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            isHistory ? AppLocalizations.of(context)!.ticket_detail_title : AppLocalizations.of(context)!.ticket_payment_success,
            style: AppTextStyles.titleLarge.copyWith(
              color: isHistory ? Colors.white : AppColors.secondary,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.background,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              if (isHistory) {
                Navigator.pop(context);
              } else {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                ClipPath(
                  clipper: TicketClipper(),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.88,
                    height: 600,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TicketMovieInfo(
                                posterUrl: posterUrl,
                                movieTitle: movieTitle,
                                genres: genresStr,
                              ),
                              const SizedBox(height: 24),
                              TicketDateRow(
                                timeStr: timeStr,
                                dateStr: dateStr,
                                roomNameText: roomNameText,
                                seatsLabel: seatsLabel,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Divider(color: Colors.black12, thickness: 1),
                              ),
                              TicketInfoRow(
                                icon: Icons.monetization_on_outlined,
                                text: "${totalPrice.toInt()} VND",
                              ),
                              const SizedBox(height: 12),
                              TicketInfoRow(
                                icon: Icons.location_on_outlined,
                                text: "$cinemaNameText\n${AppLocalizations.of(context)!.ticket_available_branch}",
                                isBold: false,
                              ),
                              const SizedBox(height: 12),
                              TicketInfoRow(
                                icon: Icons.fastfood_outlined,
                                text: comboText,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 140,
                          left: 15,
                          right: 15,
                          child: const TicketDashedLine(),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 0,
                          right: 0,
                          child: TicketQrSection(orderId: orderId),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.receipt_long, color: Colors.white70, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.ticket_barcode_instruction,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}