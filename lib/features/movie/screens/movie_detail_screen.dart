import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/models/movie.dart';
import '../../../data/models/showtime.dart';
import '../../../data/models/movie_detail.dart';
import '../../movie/providers/movie_detail_provider.dart';
import '../../../routes/app_routes.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isDataLoaded = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    // CHUẨN HÓA DỮ LIỆU MOCK: Đổi id thành 3 để khớp chính xác movie_id trong DB phpMyAdmin
    final Movie movie = args is Movie
        ? args
        : Movie(
       id: 3, // Bắt buộc giữ ID = 3 để gọi API lấy suất chiếu động
          title: "Tên mới", // Khớp cột 'title' dưới DB của bạn
          duration: 160, // Khớp cột 'duration' (160 phút)
          genres: ["Hành động", "Phiêu lưu", "Khoa học viễn tưởng"], // Đầy đủ mảng thể loại
          directors: ["Anthony Russo", "Joe Russo"], // Khớp mảng JSON đạo diễn
          releaseDate: DateTime(2026, 04, 01), // Khớp 'release_date' (2026-04-01)
          endDate: DateTime(2026, 06, 30), // Khớp 'end_date' (2026-06-30)
          status: "now_showing",
          posterUrl: "https://image.tmdb.org/t/p/original/7WsyChvRStvT0tO0Zwr0jYvjsPb.jpg", // Thay bằng link ảnh thật hiển thị cho đẹp mắt thay vì example.com bị lỗi
          description: "Mô tả phim: Đây là siêu phẩm điện ảnh được đồng bộ dữ liệu trực tiếp từ hệ thống Backend Node.js và cơ sở dữ liệu MySQL. Trận chiến thế kỷ chuẩn bị bắt đầu!", 
          ageRating: "T16", // Khớp cột 'age_rating'
          language: "Vietsub / Lồng Tiếng", // Khớp cột 'language'
          createdAt: DateTime.parse("2026-04-04 20:39:59"), // Khớp cột 'created_at'
          cast: [
            {
              'name': 'Robert Downey Jr.',
              'image': 'https://image.tmdb.org/t/p/original/1YjdSym1jTG7xjHSI0EERcA4nC.jpg',
            },
            {
              'name': 'Chris Evans',
              'image': 'https://image.tmdb.org/t/p/original/3bOGNsHlrswhyW79uvIHH1V43JI.jpg',
            },
            {
              'name': 'Mark Ruffalo',
              'image': 'https://image.tmdb.org/t/p/original/z3dvKqMNDQWk3QLxzumloQVR0L.jpg',
            },
          ],
          );

    final provider = Provider.of<MovieDetailProvider>(context);

    if (!_isDataLoaded) {
      Future.microtask(() => provider.loadShowtimes(movie.id));
      _isDataLoaded = true;
    }

    return Scaffold(
      body: Stack(
        children: [
          // 1. Poster Phim
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: movie.posterUrl.isNotEmpty
                ? Image.network(movie.posterUrl, fit: BoxFit.cover)
                : Container(color: Colors.grey[900]),
          ),

          // 2. Nút Quay Lại (Back)
          Positioned(
            top: 50,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
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

          // 3. Khối nội dung cuộn
          provider.isLoading
              ? const Center(child: LoadingIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.35,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.heroName,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.secondary,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(movie.title, style: AppTextStyles.headlineMedium),
                        const SizedBox(height: 8),
                        Text(
                          '${movie.formattedDuration} • ${movie.formattedReleaseDate}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),

                        MovieRatingSection(movie: movie),
                        const SizedBox(height: 20),

                        MovieMetadataRow(movie: movie),
                        const SizedBox(height: 24),

                        MovieStorylineSection(movie: movie),
                        const SizedBox(height: 24),

                        HorizontalDirectorList(movie: movie),
                        const SizedBox(height: 24),

                        HorizontalActorList(movie: movie),
                        const SizedBox(height: 24),

                        // Thanh lịch chọn ngày thông minh
                        _buildSmartDateSelection(provider),
                        const SizedBox(height: 24),

                        // Danh sách rạp & giờ chiếu từ Backend
                        _buildBackendCinemaSelection(provider),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),

          // 4. Nút bấm Continue nổi
          _buildContinueFloatingButton(provider, movie),
        ],
      ),
    );
  }

  // THUẬT TOÁN QUÉT NGÀY CHIẾU THÔNG MINH
  Widget _buildSmartDateSelection(MovieDetailProvider provider) {
    // 💡 CẢI TIẾN CHÍ MẠNG: Nếu danh sách suất chiếu từ BE chưa tải xong,
    // bắt UI dừng lại hiển thị một khoảng trống, không được tự ý lấy DateTime.now() làm lệch mốc!
    if (provider.allShowtimes.isEmpty) {
      return const SizedBox.shrink();
    }

    // Khi đã chạy xuống đây, chắc chắn allShowtimes đã có dữ liệu thật từ DB
    final DateTime anchorDate = provider.allShowtimes.first.startTime.toLocal();

    // Chuẩn hóa đưa giờ phút giây về 00:00:00 để so sánh Ngày/Tháng/Năm thuần túy
    final DateTime normalizedAnchor = DateTime(
      anchorDate.year,
      anchorDate.month,
      anchorDate.day,
    );

    // Đồng bộ trạng thái: Nếu ngày được chọn chưa trùng với ngày suất chiếu trong DB, ép chọn luôn ngày đầu tiên
    if (provider.selectedDate == null ||
        provider.selectedDate!.year != normalizedAnchor.year ||
        provider.selectedDate!.month != normalizedAnchor.month ||
        provider.selectedDate!.day != normalizedAnchor.day) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.selectDate(normalizedAnchor);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Chọn ngày chiếu", showSeeAll: false),
        const SizedBox(height: 12),
        SizedBox(
          height: 95,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              // Lịch chiếu luôn luôn chạy chuẩn từ ngày trong DB trở đi (Ví dụ: 01/06, 02/06...)
              final date = normalizedAnchor.add(Duration(days: index));

              bool isSelected =
                  provider.selectedDate?.day == date.day &&
                  provider.selectedDate?.month == date.month &&
                  provider.selectedDate?.year == date.year;

              return GestureDetector(
                onTap: () => provider.selectDate(date),
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
                      color: isSelected
                          ? AppColors.secondary
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${date.day}',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: isSelected
                              ? AppColors.secondary
                              : AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Thg ${date.month}",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isSelected
                              ? AppColors.secondary
                              : AppColors.textSecondary,
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

 Widget _buildBackendCinemaSelection(MovieDetailProvider provider) {
  if (provider.selectedDate == null) {
    return const Center(child: Text("Vui lòng chọn ngày chiếu"));
  }

  // DEBUG: Log thông tin filter gốc của bạn
  print("🔍 Filter Cinema - selectedDate: ${provider.selectedDate}");
  print("🔍 Tổng số suất chiếu nhận được từ BE: ${provider.allShowtimes.length}");

  // Lọc rạp theo Ngày/Tháng/Năm chuẩn hóa
  final filteredShowtimes = provider.allShowtimes.where((st) {
    final localTime = st.startTime.toLocal();
    final match =
        localTime.day == provider.selectedDate?.day &&
        localTime.month == provider.selectedDate?.month &&
        localTime.year == provider.selectedDate?.year;
    if (!match) {
      print(
        "  ❌ Lọc bỏ: ID=${st.id}, ngày=${localTime.day}/${localTime.month}/${localTime.year}",
      );
    }
    return match;
  }).toList();

  print("🔍 Sau filter: ${filteredShowtimes.length} suất chiếu");

  // Gom cụm danh sách tên rạp (Xử lý an toàn nếu trường cinema hoặc name bị null từ DB)
  final availableCinemas = filteredShowtimes
      .map((st) => st.cinema?.name ?? "Rạp chiếu đối tác")
      .toSet()
      .toList();

  print("🔍 Các rạp có suất chiếu: $availableCinemas");

  if (availableCinemas.isEmpty) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          "Không có suất chiếu nào cho ngày này",
          style: TextStyle(
            color: Colors.white30,
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
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
        bool isCinemaSelected = provider.selectedCinemaName == cinemaName;

        // 💡 SỬA LỖI CHÍ MẠNG TẠI ĐÂY: Đồng bộ hóa chuỗi kiểm tra tên rạp "Rạp chiếu đối tác" 
        // Tránh việc so sánh null == "Rạp chiếu đối tác" làm mất suất chiếu bên trong widget Wrap
        final currentShowtimes = provider.allShowtimes.where((st) {
          final localTime = st.startTime.toLocal();
          
          final isSameDate = localTime.day == provider.selectedDate?.day &&
              localTime.month == provider.selectedDate?.month &&
              localTime.year == provider.selectedDate?.year;
              
          final currentCinemaName = st.cinema?.name ?? "Rạp chiếu đối tác";
          
          return isSameDate && currentCinemaName == cinemaName;
        }).toList();

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCinemaSelected
                  ? AppColors.secondary
                  : Colors.transparent,
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
                    const Icon(
                      Icons.movie_creation_outlined,
                      color: Colors.redAccent,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    // Giữ nguyên widget Expanded fix lỗi tràn màn hình đã làm ở bước trước
                    Expanded(
                      child: Text(
                        cinemaName,
                        style: AppTextStyles.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      isCinemaSelected
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
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
                    final localStTime = st.startTime.toLocal();
                    final timeStr =
                        "${localStTime.hour.toString().padLeft(2, '0')}:${localStTime.minute.toString().padLeft(2, '0')}";
                    bool isTimeSelected =
                        provider.selectedShowtime?.id == st.id;

                    return GestureDetector(
                      onTap: () => provider.selectShowtime(st),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isTimeSelected
                              ? AppColors.secondary
                              : Colors.grey.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isTimeSelected
                                ? AppColors.secondary
                                : Colors.white10,
                          ),
                        ),
                        child: Text(
                          timeStr,
                          style: TextStyle(
                            color: isTimeSelected
                                ? Colors.black
                                : Colors.white,
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

  Widget _buildContinueFloatingButton(
    MovieDetailProvider provider,
    Movie movie,
  ) {
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
                    'showtime': provider.selectedShowtime,
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
// CÁC WIDGET CLASSES PHỤ TRỢ (GIỮ NGUYÊN ĐỂ KHÔNG BỊ LỖI GẠCH ĐỎ)
// ============================================================================

class MovieRatingSection extends StatefulWidget {
  final Movie movie;
  const MovieRatingSection({super.key, required this.movie});
  @override
  State<MovieRatingSection> createState() => _MovieRatingSectionState();
}

class _MovieRatingSectionState extends State<MovieRatingSection> {
  int _userRating = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Review", style: AppTextStyles.titleSmall),
        const SizedBox(width: 8),
        const Icon(Icons.star, color: Colors.amber, size: 18),
        Text(
          " ${widget.movie.rating.toStringAsFixed(1)}",
          style: AppTextStyles.bodyMedium,
        ),
        Text(
          " (${widget.movie.reviewCount})",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Row(
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () => setState(() => _userRating = index + 1),
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.star,
                  color: index < _userRating
                      ? AppColors.secondary
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
      crossAxisAlignment: CrossAxisAlignment.start, // 💡 Căn đỉnh các cột để khi có cột xuống dòng nhìn UI vẫn thẳng hàng
      children: [
        // 1. Cột Thể loại (Bọc Expanded vì dữ liệu này dễ dài nhất)
        Expanded(
          flex: 4, // Chiếm tỉ lệ không gian rộng hơn một chút cho thể loại
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Genre", style: AppTextStyles.bodyMedium),
              const SizedBox(height: 4),
              Text(
                movie.formattedGenres,
                style: AppTextStyles.titleSmall,
                maxLines: 2, // Cho phép xuống tối đa 2 dòng nếu quá nhiều thể loại
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8), // Khoảng cách an toàn giữa các cột

        // 2. Cột Nhãn độ tuổi
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Censorship", style: AppTextStyles.bodyMedium),
              const SizedBox(height: 4),
              Text(
                movie.ageRating,
                style: AppTextStyles.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // 3. Cột Ngôn ngữ
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Language", style: AppTextStyles.bodyMedium),
              const SizedBox(height: 4),
              Text(
                movie.language,
                style: AppTextStyles.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movie.directors.length,
            itemBuilder: (context, index) {
              return Container(
                width: 90,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey[800],
                      child: const Icon(Icons.person, color: Colors.white38),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      movie.directors[index],
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

class HorizontalActorList extends StatelessWidget {
  final Movie movie;
  const HorizontalActorList({super.key, required this.movie});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Actor", showSeeAll: false),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movie.cast.length,
            itemBuilder: (context, index) {
              final actor = movie.cast[index];
              return Container(
                width: 90,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey[800],
                      backgroundImage:
                          actor['image'] != null && actor['image']!.isNotEmpty
                          ? NetworkImage(actor['image']!)
                          : null,
                      child: actor['image'] == null || actor['image']!.isEmpty
                          ? const Icon(Icons.person, color: Colors.white38)
                          : null,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      actor['name'] ?? '',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
