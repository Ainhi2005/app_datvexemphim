import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../home/screens/home_screen.dart';
import '../../movie/screens/movie_screen.dart';
import '../../profile/screens/profile_screen.dart'; 
import '../../profile/providers/profile_provider.dart';
import '../../ticket/screens/ticket_list_screen.dart';
import '../../auth/providers/auth_provider.dart';
import 'package:tet/core/l10n/app_localizations.dart';

// ================================================================
// MAIN SCREEN - Nơi quản lý Bottom Navigation Bar CỐ ĐỊNH
// ================================================================
// MỤC ĐÍCH:
//   - Quản lý 4 màn hình chính (Trang chủ, Vé, Phim, Hồ sơ)
//   - Bottom navigation bar CỐ ĐỊNH ở dưới, không bị cuốn khi scroll
//   - Chuyển đổi giữa các màn hình mà KHÔNG cần reload lại toàn bộ
// ================================================================
// CÁCH HOẠT ĐỘNG:
//   1. Người dùng nhấn vào icon trên bottom bar
//   2. _currentIndex thay đổi (0,1,2,3)
//   3. Scaffold hiển thị widget tương ứng trong _screens[_currentIndex]
//   4. Bottom bar vẫn giữ nguyên, không thay đổi
// ================================================================
// LƯU Ý QUAN TRỌNG:
//   - Các màn hình con (HomeScreen, MovieScreen) KHÔNG có bottom nav riêng
//   - Tất cả bottom nav đều tập trung tại file NÀY
//   - Khi thêm màn hình mới, chỉ cần thêm vào _screens và _navItems
// ================================================================
class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthProvider>().isAuthenticated) {
        context.read<ProfileProvider>().fetchProfile();
      }
    });
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const TicketListScreen(),
    const MovieScreen(),
    const ProfileScreen(),
  ];

  late List<NavItem> _navItems;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = AppLocalizations.of(context)!;
    _navItems = [
      NavItem(Icons.home, lang.main_tab_home),
      NavItem(Icons.confirmation_num_outlined, lang.main_tab_ticket),
      NavItem(Icons.movie_outlined, lang.main_tab_movie),
      NavItem(Icons.person_outline, lang.main_tab_profile),
    ];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            _navItems.length,
                (index) => _buildNavItem(_navItems[index], index),
          ),
        ),
      ),
    );
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppLocalizations.of(context)!.common_login_required_title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(AppLocalizations.of(context)!.common_login_required_msg, style: const TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.common_login_later, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            },
            child: Text(AppLocalizations.of(context)!.common_login, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(NavItem item, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 1 || index == 3) {
          final authProvider = context.read<AuthProvider>();
          if (!authProvider.isAuthenticated) {
            _showLoginRequiredDialog();
            return;
          }
        }
        setState(() => _currentIndex = index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            color: isSelected ? AppColors.secondary : AppColors.textSecondary,
            size: 30,
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isSelected ? AppColors.secondary : AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  const NavItem(this.icon, this.label);
}