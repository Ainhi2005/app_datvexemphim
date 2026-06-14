import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tet/routes/app_routes.dart';
import 'package:tet/data/repositories/report_repository.dart';
import 'package:tet/features/auth/providers/auth_provider.dart';
import 'package:tet/features/profile/providers/profile_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/admin_menu_button.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final ReportRepository _repo = ReportRepository();
  bool _isLoading = true;
  double _revenue = 0.0;
  int _ticketsSold = 0;
  int _activeMovies = 0;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() => _isLoading = true);
    try {
      final data = await _repo.getOverview();
      setState(() {
        _revenue = (data['totalRevenue'] ?? 0.0).toDouble();
        _ticketsSold = data['totalBookings'] ?? 0;
        _activeMovies = data['activeMovies'] ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Lỗi tải báo cáo tổng quan: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        title: const Text('Bảng Điều Khiển Admin',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadReport,
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                context.read<ProfileProvider>().clearUser();
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thống kê tổng quan',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(color: Colors.amber),
                ),
              )
            else ...[
              StatCard(title: 'Doanh thu', value: '${_revenue.toStringAsFixed(0)} đ', color: Colors.green, isFullWidth: true),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: StatCard(title: 'Vé đã bán', value: '$_ticketsSold vé', color: Colors.amber)),
                  const SizedBox(width: 8),
                  Expanded(child: StatCard(title: 'Đang chiếu', value: '$_activeMovies phim', color: Colors.blue)),
                ],
              ),
            ],
            const SizedBox(height: 24),
            const Text('Chức năng quản trị',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  AdminMenuButton(title: 'Quản lý Phim', icon: Icons.movie, onTap: () => Navigator.pushNamed(context, AppRoutes.adminMovies)),
                  AdminMenuButton(title: 'Quản lý Suất Chiếu', icon: Icons.schedule, onTap: () => Navigator.pushNamed(context, AppRoutes.adminShowtimes)),
                  AdminMenuButton(title: 'Quản lý Người Dùng', icon: Icons.people, onTap: () => Navigator.pushNamed(context, AppRoutes.adminUsers)),
                  AdminMenuButton(title: 'Quản lý Rạp & Phòng', icon: Icons.business, onTap: () => Navigator.pushNamed(context, AppRoutes.adminCinemas)),
                  AdminMenuButton(title: 'Báo cáo doanh thu', icon: Icons.bar_chart, onTap: () => Navigator.pushNamed(context, AppRoutes.adminReports)),
                  AdminMenuButton(title: 'Quản lý Combo', icon: Icons.fastfood, onTap: () => Navigator.pushNamed(context, AppRoutes.adminCombos)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
