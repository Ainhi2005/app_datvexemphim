import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/movie.dart';  // ĐỔI từ movie_detail sang movie

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  int _selectedTab = 0; // 0: Now playing, 1: Coming soon

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Movies',
            style: AppTextStyles.headlineMedium,
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Consumer<MovieProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.secondary),
              );
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text('Lỗi: ${provider.error}', style: AppTextStyles.bodyLarge),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchMovies(),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Tab Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTab = 0;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _selectedTab == 0
                                    ? AppColors.secondary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Now playing',
                                  style: TextStyle(
                                    color: _selectedTab == 0
                                        ? Colors.white
                                        : Colors.white70,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTab = 1;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _selectedTab == 1
                                    ? AppColors.secondary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Coming soon',
                                  style: TextStyle(
                                    color: _selectedTab == 1
                                        ? Colors.white
                                        : Colors.white70,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Danh sách phim dạng lưới 2 cột
                Expanded(
                  child: _selectedTab == 0
                      ? _buildNowPlayingGrid(provider.nowPlayingMovies)
                      : _buildComingSoonGrid(provider.comingSoonMovies),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Grid cho Now playing (2 cột, card dọc)
  Widget _buildNowPlayingGrid(List<Movie> movies) {  // ĐỔI sang Movie
    if (movies.isEmpty) {
      return const Center(
        child: Text('Không có phim đang chiếu', style: TextStyle(color: Colors.white70)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _buildMovieVerticalCard(movie, isNowPlaying: true);
      },
    );
  }

  // Grid cho Coming soon (2 cột, card dọc)
  Widget _buildComingSoonGrid(List<Movie> movies) {  // ĐỔI sang Movie
    if (movies.isEmpty) {
      return const Center(
        child: Text('Không có phim sắp chiếu', style: TextStyle(color: Colors.white70)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _buildMovieVerticalCard(movie, isNowPlaying: false);
      },
    );
  }

  // Card phim dạng dọc (cho grid)
  Widget _buildMovieVerticalCard(Movie movie, {required bool isNowPlaying}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh phim
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              movie.posterUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: AppColors.primary,
                child: const Icon(Icons.movie, size: 40, color: Colors.grey),
              ),
            ),
          ),
          // Nội dung
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero name (lấy từ title)
                const SizedBox(height: 4),
                // Title
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Rating hoặc Release date
                if (isNowPlaying)
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Color(0xFFFFD700)),
                      const SizedBox(width: 4),
                      Text(
                        '${movie.rating} (${movie.reviewCount})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 12, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text(
                        movie.formattedReleaseDate,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 6),
                // Duration
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Colors.white54),
                    const SizedBox(width: 4),
                    Text(
                      movie.formattedDuration,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Genre
                Text(
                  movie.formattedGenres,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}