import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/movie.dart';
import '../../../routes/app_routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/showtime_provider.dart';

class ContinueFloatingButton extends StatelessWidget {
  final ShowtimeProvider showtimeProvider;
  final Movie movie;

  const ContinueFloatingButton({
    super.key,
    required this.showtimeProvider,
    required this.movie,
  });

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Yêu cầu đăng nhập', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('Bạn cần đăng nhập để thực hiện đặt vé xem phim.', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Để sau', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            },
            child: const Text('Đăng nhập', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          disabledBackgroundColor: Colors.grey[800],
        ),
        onPressed: showtimeProvider.selectedShowtime == null
            ? null
            : () {
                final authProvider = context.read<AuthProvider>();
                if (!authProvider.isAuthenticated) {
                  _showLoginRequiredDialog(context);
                  return;
                }
                Navigator.pushNamed(
                  context,
                  AppRoutes.selectSeat,
                  arguments: {
                    'movie': movie,
                    'showtime': showtimeProvider.selectedShowtime!,
                  },
                );
              },
        child: const Text(
          "Continue",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
