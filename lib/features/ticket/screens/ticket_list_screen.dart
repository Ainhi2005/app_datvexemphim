// lib/features/ticket/screens/ticket_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/ticket_provider.dart';
import '../providers/ticket_provider.dart';
import '../widgets/ticket_card_item.dart';
import 'package:tet/core/l10n/app_localizations.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  late Future<List<dynamic>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = context.read<TicketProvider>().getMyTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.ticket_my_tickets,
          style: AppTextStyles.titleLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _ticketsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.secondary));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "${AppLocalizations.of(context)!.ticket_error_occurred}${snapshot.error}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.ticket_no_tickets, style: const TextStyle(color: Colors.white54)),
            );
          }

          final tickets = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              return TicketCardItem(baseTicket: tickets[index]);
            },
          );
        },
      ),
    );
  }
}