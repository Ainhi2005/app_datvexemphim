import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/now_playing_carousel.dart';
import '../../home/providers/home_provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          HomeProvider(), // Khởi tạo Provider để tải danh sách phim từ API
      child: Scaffold(
        backgroundColor: Colors.black, // Nền đen tuyền theo thiết kế
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 1. Logo FILMGO ở trên cùng
              // 1. Logo FILMGO ở trên cùng
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Thay thế Icon bằng Image.asset:
                  Image.asset(
                    'assets/images/logo.png', // Thay 'logo.png' bằng tên file ảnh của bạn
                    height: 40, // Chiều cao tương đương với Icon cũ
                    width: 40, // Chiều rộng tương đương
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'FILMGO',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              // 2. Carousel chạy phim tự động từ Core (đã cấu hình thu nhỏ)
              Expanded(
                child: Consumer<HomeProvider>(
                  builder: (context, homeProvider, child) {
                    if (homeProvider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.secondary,
                        ),
                      );
                    }
                    if (homeProvider.nowPlaying.isEmpty) {
                      return const Center(
                        child: Text(
                          'Không có phim đang chiếu',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    // Truyền thông số thu nhỏ ở đây:
                    // Gọi bộ Carousel chạy tự động và ẩn chữ/chấm đi:
                    return NowPlayingCarousel(
                      movies: homeProvider.nowPlaying,
                      height:
                          400, // Chỉnh chiều cao phù hợp khi chỉ có ảnh (khoảng 220 - 280)
                      imageHeightActive: 350, // Chiều cao ảnh đang chọn
                      imageHeightInactive: 280, // Chiều cao ảnh bên cạnh
                      viewportFraction: 0.82, // Thu hẹp chiều rộng card còn 62%
                      showDetails:
                          false, // <-- ẨN TOÀN BỘ CHỮ VÀ CHẤM DƯỚI ẢNH CAROUSEL
                    );
                  },
                ),
              ),
              SizedBox(height: 30),
              Text("Đặt vé dễ dàng với FILMGO"),

              const SizedBox(height: 16),

              // 3. Cụm nút bấm Đăng nhập & Đăng ký ở dưới cùng
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.textButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    AppStrings.signIn,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    side: const BorderSide(color: Colors.white70, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    AppStrings.signUp,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
