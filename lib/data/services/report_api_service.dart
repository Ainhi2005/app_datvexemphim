import '../../core/utils/dio_client.dart';

class ReportApiService {
  final _dioClient = DioClient();

  Future<Map<String, dynamic>> getOverview() async {
    final response = await _dioClient.dio.get('/reports/overview');
    return response.data;
  }

  Future<Map<String, dynamic>> getRevenueByMovie() async {
    final response = await _dioClient.dio.get('/reports/revenue/movies');
    return response.data;
  }

  Future<Map<String, dynamic>> getRevenueByCinema() async {
    final response = await _dioClient.dio.get('/reports/revenue/cinemas');
    return response.data;
  }

  Future<Map<String, dynamic>> getRevenueByTime() async {
    final response = await _dioClient.dio.get('/reports/revenue/time');
    return response.data;
  }
}
