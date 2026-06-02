import 'package:flutter/material.dart';
import 'dart:async';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../../data/models/movie.dart';

// Thay thế đoạn định nghĩa class NowPlayingCarousel và State cũ bằng đoạn này:

class NowPlayingCarousel extends StatefulWidget {
  final List<Movie> movies;
  final double height; // Chiều cao toàn bộ khối carousel
  final double imageHeightActive; // Chiều cao của ảnh đang được chọn
  final double imageHeightInactive; // Chiều cao của các ảnh bên cạnh
  final double
  viewportFraction; // Tỉ lệ chiều rộng của mỗi card so với màn hình
  final bool showDetails;

  const NowPlayingCarousel({
    super.key,
    required this.movies,
    this.height = 500, // Giá trị mặc định (phù hợp cho Trang chủ)
    this.imageHeightActive = 400,
    this.imageHeightInactive = 380,
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
    // Thay đổi 0.75 cứng thành biến cấu hình động:
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
    final int indicatorCount = widget.movies.length > 3
        ? 3
        : widget.movies.length;
    if (widget.movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height, // Giảm chiều cao vì không còn text trong ảnh
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
                  children: [
                    // ẢNH - nằm trên
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: isActive
                          ? widget.imageHeightActive
                          : widget.imageHeightInactive,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              isActive ? 0.5 : 0.2,
                            ),
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
                              child: const Icon(
                                Icons.movie,
                                size: 50,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // THÔNG TIN - nằm dưới ảnh
                    // THÔNG TIN - nằm dưới ảnh, căn giữa
                    if (widget.showDetails) ...[
                      const SizedBox(height: 12),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isActive ? 1.0 : 0.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.center, // ✅ SỬA 1
                            children: [
                              // Tên phim
                              Text(
                                movie.title,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center, // ✅ SỬA 2
                              ),
                              const SizedBox(height: 6),
                              // Thời lượng và thể loại
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center, // Giữ nguyên
                                children: [
                                  Text(
                                    movie.formattedDuration,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Text(
                                    ' · ',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                  Flexible(
                                    // ĐỔI Expanded thành Flexible
                                    child: Text(
                                      movie.formattedGenres,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              // Rating
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center, // ✅ SỬA 5
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Color(0xFFFFD700),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${movie.rating} (${movie.reviewCount})',
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

        const SizedBox(height: 16),

        // Indicator dots
        if (widget.showDetails) ...[
          const SizedBox(height: 12),
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
