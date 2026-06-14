import '../services/ticket_api_service.dart';

class TicketRepository {
  final TicketApiService _apiService = TicketApiService();

  Future<List<dynamic>> getMyTickets() async {
    final response = await _apiService.getMyTickets();
    return response.data['data'] ?? [];
  }

  Future<Map<String, dynamic>> getTicketDetail(int bookingId) async {
    final response = await _apiService.getTicketDetail(bookingId);
    return response.data['data'];
  }
}