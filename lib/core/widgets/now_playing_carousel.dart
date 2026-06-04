import 'package:flutter/material.dart';
import 'dart:async';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../../data/models/movie.dart';
import '../../routes/app_routes.dart';

class NowPlayingCarousel extends StatefulWidget {
  final List<Movie> movies;
  final double height; // Chiều cao toàn bộ khối carousel
  final double imageHeightActive; // Chiều cao của ảnh đang được chọn
  final double imageHeightInactive; // Chiều cao của các ảnh bên cạnh
  final double viewportFraction; // Tỉ lệ chiều rộng của mỗi card so với màn hình
  final bool showDetails;

  const NowPlayingCarousel({
    super.key,
    required this.movies,
    this.height = 520, // Tăng nhẹ chiều cao tổng thể để chứa phần Text an toàn
    this.imageHeightActive = 390, // Hạ nhẹ chiều cao ảnh active xuống 10px tránh overflow
    this.imageHeightInactive = 360,
    this.viewportFraction = 0.75,
    this.showDetails = true,
  });

  @override
  State<NowPlayingCarousel> createState() => _NowPlayingCarouselState();
}

class _NowPlayingCarouselState extends State<NowPlayingCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewportFraction);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (widget.movies.isNotEmpty) {
        final nextPage = (_currentPage + 1) % widget.movies.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int indicatorCount = widget.movies.length > 3 ? 3 : widget.movies.length;
    
    if (widget.movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height, 
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.movies.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
            final movie = widget.movies[index];
            final isActive = index == _currentPage;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 💡 BỌC GESTURE DETECTOR VÀO ĐÂY ĐỂ BẮT SỰ KIỆN CLICK
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.movieDetail, // Thay bằng tên Route chi tiết phim trong AppRoutes của bạn (Vd: AppRoutes.movieDetail)
                        arguments: movie, // Truyền trực tiếp Object movie sang màn hình detail
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: isActive
                          ? widget.imageHeightActive
                          : widget.imageHeightInactive,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isActive ? 0.5 : 0.2),
                            blurRadius: isActive ? 15 : 8,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Opacity(
                        opacity: isActive ? 1.0 : 0.6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            movie.posterUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.cardColor,
                              child: const Icon(Icons.movie, size: 50, color: Colors.white54),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
        // Phần thông tin chi tiết phim bên dưới giữ nguyên...

                    // 2. PHẦN THÔNG TIN CHI TIẾT DƯỚI ẢNH (CHỈ HIỂN THỊ KHI ACTIVED)
                    if (widget.showDetails) ...[
                      const SizedBox(height: 8), // Khoảng đệm dọc tối ưu chống tràn
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isActive ? 1.0 : 0.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, 
                            children: [
                              // Tên phim
                              Text(
                                movie.title,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center, 
                              ),
                              const SizedBox(height: 4),
                              
                              // Thời lượng và thể loại phim kết hợp
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center, 
                                children: [
                                  Text(
                                    movie.formattedDuration,
                                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                                  ),
                                  const Text(
                                    ' · ',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                  Flexible(
                                    child: Text(
                                      movie.formattedGenres,
                                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              
                              // Khối hiển thị điểm số và đánh giá (Hệ dữ liệu Model mới)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center, 
                                children: [
                                  const Icon(Icons.star, size: 14, color: Color(0xFFFFD700)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${movie.rating.toStringAsFixed(1)} (${movie.reviewCount})',
                                    style: const TextStyle(
                                      color: Color(0xFFFFD700),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),

        // 3. THANH ĐIỀU HƯỚNG CHẤM TRÒN (INDICATOR DOTS) NẰM NGOÀI PAGEVIEW
        if (widget.showDetails) ...[
          const SizedBox(height: 8), 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(indicatorCount, (index) {
              final activeIndex = _currentPage % indicatorCount;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: activeIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: activeIndex == index
                      ? AppColors.secondary
                      : Colors.white38,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}