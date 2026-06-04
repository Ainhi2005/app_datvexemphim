// lib/presentation/movie/screens/movie_detail_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/models/movie.dart';
import '../../../data/models/showtime.dart';
import '../../movie/providers/movie_detail_provider.dart';
import '../../../routes/app_routes.dart';
import '../providers/showtime_provider.dart';
import '../providers/rating_provider.dart'; // Nạp tầng xử lý đánh giá phim
import '../../auth/providers/auth_provider.dart'; // Nạp tầng quản lý tài khoản để lấy token đăng nhập

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isMovieDataLoaded = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    final Movie movie = args is Movie
        ? args
        : Movie(
            id: 4,
            title: "Godzilla x Kong: The New Empire",
            duration: 115,
            genres: ["Hành động", "Khoa học viễn tưởng"],
            directors: ["Adam Wingard"],
            releaseDate: DateTime.parse("2026-03-24T17:00:00.000Z"),
            endDate: DateTime.parse("2026-06-14T17:00:00.000Z"),
            status: "now_showing",
            posterUrl:
                "https://res.cloudinary.com/dacgrbxyn/image/upload/v1778338063/cinema-app/sd6sogl7oeiqphu6encg.jpg",
            description:
                "Cuộc chiến siêu kinh điển giữa các Titan cổ đại chống lại mối đe dọa tiềm ẩn sâu bên trong thế giới Trái Đất rỗng.",
            ageRating: "T13",
            language: "Vietsub",
            createdAt: DateTime.parse("2026-04-17T03:50:43.000Z"),
          );

    final movieDetailProvider = Provider.of<MovieDetailProvider>(context);
    final showtimeProvider = Provider.of<ShowtimeProvider>(context);
    final ratingProvider = Provider.of<RatingProvider>(context);

    // Kích hoạt nạp thông tin mô tả bộ phim và danh sách rating động
    if (!_isMovieDataLoaded) {
      Future.microtask(() {
        movieDetailProvider.loadMovieDetailData(movie.id);
        ratingProvider.fetchRatings(movie.id);
      });
      _isMovieDataLoaded = true;
    }

    if (showtimeProvider.isLoading == false && showtimeProvider.allShowtimes.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showtimeProvider.fetchShowtimes(movie.id);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Hiệu ứng Ảnh nền lớn phía sau (Blur)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: movie.posterUrl.isNotEmpty
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(movie.posterUrl, fit: BoxFit.cover),
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, AppColors.background],
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(color: Colors.grey[900]),
          ),

          // 3. Khối nội dung cuộn chính
          movieDetailProvider.isLoading
              ? const Center(child: LoadingIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.12,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 120,
                              height: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  movie.posterUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    movie.heroName,
                                    style: AppTextStyles.titleSmall.copyWith(
                                      color: AppColors.secondary,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    movie.title,
                                    style: AppTextStyles.headlineMedium
                                        .copyWith(fontSize: 22),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${movie.formattedDuration} • ${movie.formattedReleaseDate}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Section hiển thị Điểm Đánh giá lấy động từ RatingProvider mới gộp bộ chọn sao tương tác
                        MovieRatingSection(
                          movieId: movie.id,
                          averageScore: ratingProvider.averageScore,
                          totalRatings: ratingProvider.totalRatings,
                        ),
                        const SizedBox(height: 24),

                        MovieMetadataRow(movie: movie),
                        const SizedBox(height: 24),

                        MovieStorylineSection(movie: movie),
                        const SizedBox(height: 24),

                        HorizontalDirectorList(movie: movie),
                        const SizedBox(height: 24),

                        _buildSmartDateSelection(showtimeProvider),
                        const SizedBox(height: 24),

                        _buildBackendCinemaSelection(showtimeProvider),

                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),

          // 4. Thanh điều hướng đặt vé nổi dưới cùng màn hình
          if (!movieDetailProvider.isLoading)
            _buildContinueFloatingButton(showtimeProvider, movie),

          // 2. Nút Quay Lại (Back)
          Positioned(
            top: 50,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartDateSelection(ShowtimeProvider provider) {
    if (provider.allShowtimes.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<String> availableDates = provider.getAvailableDates();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Chọn ngày chiếu", showSeeAll: false),
        const SizedBox(height: 12),
        SizedBox(
          height: 95,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: availableDates.length,
            itemBuilder: (context, index) {
              final String dateStr = availableDates[index];
              bool isSelected = provider.selectedDate == dateStr;

              final parts = dateStr.split('/');
              final String dayDisplay = parts.isNotEmpty ? parts[0] : '';
              final String monthDisplay = parts.length > 1 ? parts[1] : '';

              return GestureDetector(
                onTap: () => provider.selectDate(dateStr),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondary.withOpacity(0.15)
                        : AppColors.cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.secondary : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayDisplay,
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: isSelected ? AppColors.secondary : AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Thg $monthDisplay",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isSelected ? AppColors.secondary : AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBackendCinemaSelection(ShowtimeProvider provider) {
    if (provider.selectedDate == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "Vui lòng chọn ngày chiếu",
            style: TextStyle(color: Colors.white30, fontSize: 14, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    final availableCinemas = provider.getCinemasBySelectedDate();

    if (availableCinemas.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "Không có suất chiếu nào cho ngày này",
            style: TextStyle(color: Colors.white30, fontSize: 14, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Cinema", showSeeAll: false),
        const SizedBox(height: 12),
        ...availableCinemas.map((cinemaName) {
          bool isCinemaSelected = provider.selectedCinema == cinemaName;

          final currentShowtimes = provider.allShowtimes.where((st) {
            return st.formattedDate == provider.selectedDate && st.cinemaName == cinemaName;
          }).toList();

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCinemaSelected ? AppColors.secondary : Colors.transparent,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => provider.selectCinema(cinemaName),
                  child: Row(
                    children: [
                      const Icon(Icons.movie_creation_outlined, color: Colors.redAccent, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          cinemaName,
                          style: AppTextStyles.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        isCinemaSelected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.white54,
                      ),
                    ],
                  ),
                ),
                if (isCinemaSelected) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: Colors.white10),
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: currentShowtimes.map((st) {
                      final timeStr = st.formattedTime;
                      bool isTimeSelected = provider.selectedShowtime?.id == st.id;

                      return GestureDetector(
                        onTap: () => provider.selectShowtime(st),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isTimeSelected ? AppColors.secondary : Colors.grey.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isTimeSelected ? AppColors.secondary : Colors.white10,
                            ),
                          ),
                          child: Text(
                            timeStr,
                            style: TextStyle(
                              color: isTimeSelected ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildContinueFloatingButton(ShowtimeProvider provider, Movie movie) {
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
        onPressed: provider.selectedShowtime == null
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.selectSeat,
                  arguments: {
                    'movie': movie,
                    'showtime': provider.selectedShowtime!,
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

// ============================================================================
// COMPONENT PHỤ TRỢ: TÍNH TOÁN ĐIỂM ĐỘNG & ĐÁNH GIÁ TƯƠNG TÁC QUA 5 NGÔI SAO
// ============================================================================

// lib/presentation/movie/screens/movie_detail_screen.dart

class MovieRatingSection extends StatefulWidget {
  final int movieId;
  final double averageScore;
  final int totalRatings;

  const MovieRatingSection({
    super.key,
    required this.movieId,
    required this.averageScore,
    required this.totalRatings,
  });

  @override
  State<MovieRatingSection> createState() => _MovieRatingSectionState();
}

class _MovieRatingSectionState extends State<MovieRatingSection> {
  // 💡 BIẾN TRẠNG THÁI: Lưu số sao người dùng đang bấm chọn thử (0 nghĩa là chưa chọn thử)
  int _selectedStarsTrial = 0; 

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 28),
            const SizedBox(width: 10),
            Text(title, style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
          ],
        ),
        content: Text(message, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đã hiểu", style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRatingSubmission(int ratingValue) async {
    final ratingProvider = Provider.of<RatingProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? realUserToken = authProvider.token; 

    // Gửi thang điểm gốc từ 1 đến 5 chuẩn xác theo định dạng double sang Provider
    double calculatedScore = ratingValue.toDouble();

    final String? errorMessage = await ratingProvider.submitRating(
      movieId: widget.movieId,
      score: calculatedScore,
      review: "Phim xem rất hay!",
      token: realUserToken,
    );

    if (!mounted) return;

    if (errorMessage != null) {
      _showErrorDialog(context, "Thông báo từ hệ thống", errorMessage);
      // 💡 Nếu xảy ra lỗi (chưa xem phim, trùng lặp,...), reset số sao chọn thử về 0
      setState(() => _selectedStarsTrial = 0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("🎉 Cảm ơn bạn đã gửi đánh giá thành công!", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      );
      // 💡 Gửi thành công, reset trạng thái chọn thử để UI cập nhật theo điểm trung bình mới từ Server
      setState(() => _selectedStarsTrial = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy điểm trung bình hệ 5 trực tiếp từ MySQL trả về
    double displayStars = widget.averageScore; 

    return Row(
      children: [
        const Text("Review", style: AppTextStyles.titleSmall),
        const SizedBox(width: 8),
        const Icon(Icons.star, color: Colors.amber, size: 18),
        Text(
          " ${displayStars.toStringAsFixed(1)}",
          style: AppTextStyles.bodyMedium,
        ),
        Text(
          " (${widget.totalRatings})",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        
        // Khối 5 ngôi sao tương tác thuật toán click 2 bước
        Row(
          children: List.generate(5, (index) {
            int starPositionValue = index + 1;
            
            // 💡 QUY LUẬT SÁNG SAO: Nếu đang có số sao chọn thử -> Ưu tiên sáng theo số sao chọn thử. 
            // Nếu không có chọn thử -> Sáng theo điểm trung bình hệ thống (displayStars).
            bool isLit = _selectedStarsTrial > 0 
                ? starPositionValue <= _selectedStarsTrial 
                : starPositionValue <= displayStars.floor();

            return GestureDetector(
              onTap: () {
                if (_selectedStarsTrial == starPositionValue) {
                  // 🌟 CLICK LẦN 2 (Trùng số sao đang chọn thử): Kích hoạt gửi dữ liệu thật lên MySQL
                  print('🚀 Thực hiện gửi đánh giá thật: $starPositionValue sao');
                  _handleRatingSubmission(starPositionValue);
                } else {
                  // 🌟 CLICK LẦN 1 (Hoặc đổi ý bấm số sao khác): Chỉ hiển thị màu vàng nhấp nháy chọn thử
                  print('⭐ Người dùng đang chọn thử: $starPositionValue sao (Chờ click lần 2)');
                  setState(() {
                    _selectedStarsTrial = starPositionValue;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                // Tách biệt màu sắc: Nếu đang ở chế độ "Chọn thử" thì cho màu vàng Amber rực rỡ, 
                // nếu là điểm hệ thống thì dùng màu secondary mặc định của app để phân biệt trực quan
                child: Icon(
                  Icons.star,
                  color: isLit 
                      ? (_selectedStarsTrial > 0 ? Colors.amber : AppColors.secondary)
                      : Colors.grey[700],
                  size: 24,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}


class MovieMetadataRow extends StatelessWidget {
  final Movie movie;
  const MovieMetadataRow({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Movie genre:", style: AppTextStyles.bodyMedium),
              const SizedBox(height: 4),
              Text(
                movie.formattedGenres,
                style: AppTextStyles.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Censorship:", style: AppTextStyles.bodyMedium),
              const SizedBox(height: 4),
              Text(movie.ageRating, style: AppTextStyles.titleSmall),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Language:", style: AppTextStyles.bodyMedium),
              const SizedBox(height: 4),
              Text(movie.language, style: AppTextStyles.titleSmall),
            ],
          ),
        ),
      ],
    );
  }
}

class MovieStorylineSection extends StatefulWidget {
  final Movie movie;
  const MovieStorylineSection({super.key, required this.movie});

  @override
  State<MovieStorylineSection> createState() => _MovieStorylineSectionState();
}

class _MovieStorylineSectionState extends State<MovieStorylineSection> {
  bool _isStorylineExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Storyline", showSeeAll: false),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () =>
              setState(() => _isStorylineExpanded = !_isStorylineExpanded),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: Text(
              widget.movie.description,
              maxLines: _isStorylineExpanded ? 100 : 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HorizontalDirectorList extends StatelessWidget {
  final Movie movie;
  const HorizontalDirectorList({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Director", showSeeAll: false),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movie.directors.length,
            itemBuilder: (context, index) {
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[800],
                      child: const Icon(
                        Icons.person,
                        color: Colors.white38,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        movie.directors[index],
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}