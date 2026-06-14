import '../services/report_api_service.dart';

class ReportRepository {
  final ReportApiService _apiService = ReportApiService();

  Future<Map<String, dynamic>> getOverview() async {
    final response = await _apiService.getOverview();
    if (response['success'] == true) {
      return response['data'] ?? {};
    }
    throw Exception(response['message'] ?? 'Lỗi tải báo cáo tổng quan');
  }

  Future<List<dynamic>> getRevenueByMovie() async {
    final response = await _apiService.getRevenueByMovie();
    if (response['success'] == true) {
      return response['data'] ?? [];
    }
    throw Exception(response['message'] ?? 'Lỗi tải doanh thu theo phim');
  }

  Future<List<dynamic>> getRevenueByCinema() async {
    final response = await _apiService.getRevenueByCinema();
    if (response['success'] == true) {
      return response['data'] ?? [];
    }
    throw Exception(response['message'] ?? 'Lỗi tải doanh thu theo rạp');
  }

  Future<List<dynamic>> getRevenueByTime() async {
    final response = await _apiService.getRevenueByTime();
    if (response['success'] == true) {
      return response['data'] ?? [];
    }
    throw Exception(response['message'] ?? 'Lỗi tải doanh thu theo thời gian');
  }
}
