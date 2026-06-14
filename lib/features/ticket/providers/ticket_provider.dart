import 'package:flutter/material.dart';
import '../../../data/repositories/ticket_repository.dart';

class TicketProvider extends ChangeNotifier {
  final TicketRepository _repository = TicketRepository();

  Future<List<dynamic>> getMyTickets() async => await _repository.getMyTickets();
  Future<Map<String, dynamic>> getTicketDetail(int bookingId) async => await _repository.getTicketDetail(bookingId);
}