import 'package:flutter/material.dart';
import 'dart:async';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../../data/models/movie.dart';
import '../../routes/app_routes.dart';

class NowPlayingCarousel extends StatefulWidget {
  final List<Movie> movies;
  final double height;
  final double imageHeightActive;
  final double imageHeightInactive;
  final double viewportFraction;
  final bool showDetails;
  final Function(int)? onPageChanged; // 💡 THÊM CALLBACK ĐỂ BÁO LÊN HOMESCREEN

  const NowPlayingCarousel({
    super.key,
    required this.movies,
    this.height = 540,
    this.imageHeightActive = 400,
    this.imageHeightInactive = 350,
    this.viewportFraction = 0.72, // Thu nhỏ xíu để thấy rõ 2 card bên cạnh
    this.showDetails = true,
    this.onPageChanged,
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
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (widget.movies.isNotEmpty) {
        final nextPage = (_currentPage + 1) % widget.movies.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.fastOutSlowIn,
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
    final int indicatorCount = widget.movies.length > 5
        ? 5
        : widget.movies.length;

    if (widget.movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: widget.movies.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              if (widget.onPageChanged != null) {
                widget.onPageChanged!(index);
              }
            },
            itemBuilder: (context, index) {
              final movie = widget.movies[index];
              final isActive = index == _currentPage;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.movieDetail,
                          arguments: movie,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutQuart,
                        height: isActive
                            ? widget.imageHeightActive
                            : widget.imageHeightInactive,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: const Color.fromARGB(
                                      255,
                                      220,
                                      219,
                                      216,
                                    ).withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                movie.posterUrl,
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
                              // Phủ gradient đen từ dưới lên để làm nổi bật text
                              if (isActive && widget.showDetails)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  height: 200,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.9),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              // Hiệu ứng mờ cho ảnh không active
                              if (!isActive)
                                Container(color: Colors.black.withValues(alpha: 0.5)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    if (widget.showDetails) ...[
                      const SizedBox(height: 16),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isActive ? 1.0 : 0.0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          transform: Matrix4.translationValues(
                            0,
                            isActive ? 0 : 10,
                            0,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                movie.title,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    movie.formattedDuration,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontSize: 13,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      '•',
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      movie.formattedGenres,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontSize: 13,
                                        color: Colors.white70,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
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

        if (widget.showDetails) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(indicatorCount, (index) {
              final activeIndex = _currentPage % indicatorCount;
              final isActive = activeIndex == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.secondary : Colors.white24,
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
