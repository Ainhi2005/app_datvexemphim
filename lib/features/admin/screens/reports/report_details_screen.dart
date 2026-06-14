import 'package:flutter/material.dart';
import 'package:tet/data/repositories/report_repository.dart';
import 'widgets/report_summary_card.dart';
import 'widgets/revenue_bar_item.dart';

class ReportDetailsScreen extends StatefulWidget {
  const ReportDetailsScreen({super.key});

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen>
    with SingleTickerProviderStateMixin {
  final ReportRepository _repo = ReportRepository();
  late TabController _tabController;

  bool _isLoading = true;
  Map<String, dynamic> _overview = {};
  List<dynamic> _movieRevenue = [];
  List<dynamic> _cinemaRevenue = [];
  List<dynamic> _timeRevenue = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── Data ──────────────────────────────────────────────────────────────────

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _repo.getOverview(),
        _repo.getRevenueByMovie(),
        _repo.getRevenueByCinema(),
        _repo.getRevenueByTime(),
      ]);
      setState(() {
        _overview = results[0] as Map<String, dynamic>;
        _movieRevenue = results[1] as List<dynamic>;
        _cinemaRevenue = results[2] as List<dynamic>;
        _timeRevenue = results[3] as List<dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải báo cáo chi tiết: $e')),
      );
    }
  }

  double _maxRevenue(List<dynamic> list) {
    double max = 0;
    for (final item in list) {
      final double rev = (item['revenue'] ?? 0.0).toDouble();
      if (rev > max) max = rev;
    }
    return max == 0 ? 1.0 : max;
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : NestedScrollView(
              headerSliverBuilder: (context, _) => [
                SliverAppBar(
                  title: const Text('Báo Cáo Doanh Thu',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  backgroundColor: const Color(0xFF121212),
                  floating: false,
                  pinned: true,
                  expandedHeight: 310,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _loadAll,
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: const EdgeInsets.only(top: 80, left: 16, right: 16, bottom: 56),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ReportSummaryCard(
                            title: 'Doanh Thu',
                            value: '${(_overview['totalRevenue'] ?? 0.0).toStringAsFixed(0)} đ',
                            icon: Icons.monetization_on_outlined,
                            color: Colors.greenAccent,
                            horizontal: true,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: ReportSummaryCard(
                                  title: 'Vé Đã Bán',
                                  value: '${_overview['totalBookings'] ?? 0} vé',
                                  icon: Icons.local_activity_outlined,
                                  color: Colors.amberAccent,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ReportSummaryCard(
                                  title: 'Đang Chiếu',
                                  value: '${_overview['activeMovies'] ?? 0} phim',
                                  icon: Icons.movie_filter_outlined,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    controller: _tabController,
                    labelColor: Colors.amber,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.amber,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'Theo Phim'),
                      Tab(text: 'Theo Rạp'),
                      Tab(text: 'Thời Gian'),
                    ],
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildMovieTab(),
                  _buildCinemaTab(),
                  _buildTimeTab(),
                ],
              ),
            ),
    );
  }

  // ─── Tabs ──────────────────────────────────────────────────────────────────

  Widget _buildMovieTab() {
    if (_movieRevenue.isEmpty) {
      return const Center(child: Text('Chưa có dữ liệu doanh thu phim', style: TextStyle(color: Colors.grey)));
    }
    final double max = _maxRevenue(_movieRevenue);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _movieRevenue.length,
      itemBuilder: (_, i) {
        final item = _movieRevenue[i];
        final double rev = (item['revenue'] ?? 0.0).toDouble();
        return RevenueBarItem(
          label: item['title'] ?? 'Phim không tên',
          revenue: rev,
          ratio: rev / max,
          barColor: Colors.amber,
        );
      },
    );
  }

  Widget _buildCinemaTab() {
    if (_cinemaRevenue.isEmpty) {
      return const Center(child: Text('Chưa có dữ liệu doanh thu rạp', style: TextStyle(color: Colors.grey)));
    }
    final double max = _maxRevenue(_cinemaRevenue);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _cinemaRevenue.length,
      itemBuilder: (_, i) {
        final item = _cinemaRevenue[i];
        final double rev = (item['revenue'] ?? 0.0).toDouble();
        return RevenueBarItem(
          label: item['cinemaName'] ?? 'Rạp không tên',
          revenue: rev,
          ratio: rev / max,
          barColor: Colors.greenAccent,
        );
      },
    );
  }

  Widget _buildTimeTab() {
    if (_timeRevenue.isEmpty) {
      return const Center(child: Text('Chưa có dữ liệu doanh thu theo ngày', style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _timeRevenue.length,
      itemBuilder: (_, i) {
        final item = _timeRevenue[i];
        final double rev = (item['revenue'] ?? 0.0).toDouble();
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.show_chart, color: Colors.blueAccent, size: 20),
            ),
            title: Text(item['date'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
            trailing: Text(
              '${rev.toStringAsFixed(0)} đ',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        );
      },
    );
  }
}
