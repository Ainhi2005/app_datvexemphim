import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tet/routes/app_routes.dart';
import 'package:tet/data/repositories/report_repository.dart';
import 'package:tet/features/auth/providers/auth_provider.dart';
import 'package:tet/features/profile/providers/profile_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/admin_menu_button.dart';
import 'package:tet/core/l10n/app_localizations.dart';

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
      debugPrint('${AppLocalizations.of(context)!.admin_error_loading_report}$e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.admin_dashboard_title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            Text(AppLocalizations.of(context)!.admin_overview_stats,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(color: Colors.amber),
                ),
              )
            else ...[
              StatCard(title: AppLocalizations.of(context)!.admin_revenue, value: '${_revenue.toStringAsFixed(0)}${AppLocalizations.of(context)!.admin_currency_unit}', color: Colors.green, isFullWidth: true),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: StatCard(title: AppLocalizations.of(context)!.admin_tickets_sold, value: '$_ticketsSold${AppLocalizations.of(context)!.admin_ticket_unit}', color: Colors.amber)),
                  const SizedBox(width: 8),
                  Expanded(child: StatCard(title: AppLocalizations.of(context)!.admin_active_movies, value: '$_activeMovies${AppLocalizations.of(context)!.admin_movie_unit}', color: Colors.blue)),
                ],
              ),
            ],
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.admin_management_functions,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  AdminMenuButton(title: AppLocalizations.of(context)!.admin_manage_movies, icon: Icons.movie, onTap: () => Navigator.pushNamed(context, AppRoutes.adminMovies)),
                  AdminMenuButton(title: AppLocalizations.of(context)!.admin_manage_showtimes, icon: Icons.schedule, onTap: () => Navigator.pushNamed(context, AppRoutes.adminShowtimes)),
                  AdminMenuButton(title: AppLocalizations.of(context)!.admin_manage_users, icon: Icons.people, onTap: () => Navigator.pushNamed(context, AppRoutes.adminUsers)),
                  AdminMenuButton(title: AppLocalizations.of(context)!.admin_manage_cinemas, icon: Icons.business, onTap: () => Navigator.pushNamed(context, AppRoutes.adminCinemas)),
                  AdminMenuButton(title: AppLocalizations.of(context)!.admin_revenue_reports, icon: Icons.bar_chart, onTap: () => Navigator.pushNamed(context, AppRoutes.adminReports)),
                  AdminMenuButton(title: AppLocalizations.of(context)!.admin_manage_combos, icon: Icons.fastfood, onTap: () => Navigator.pushNamed(context, AppRoutes.adminCombos)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
