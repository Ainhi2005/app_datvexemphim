import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/see_all_button.dart';
import '../../../core/widgets/now_playing_card.dart';
import '../../../core/widgets/movie_card.dart';
import '../../../core/widgets/news_card.dart';
import '../../../data/models/movie.dart';
import '../../movie/screens/movie_screen.dart';
import '../../../core/widgets/now_playing_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Trang Chủ',
            style: AppTextStyles.headlineMedium,
          ),
          centerTitle: false,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/68.jpg'),
              ),
            ),
          ],
        ),
        body: Consumer<HomeProvider>(
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
                      onPressed: () => provider.fetchHomeData(),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildNowPlayingSection(context,provider.nowPlaying),
                  const SizedBox(height: 32),
                  _buildComingSoonSection(context,provider.comingSoon),
                  const SizedBox(height: 24),
                  // ❌ ĐÃ XÓA Service Section
                  _buildNewsSection(provider.newsMovies),  // ĐỔI news thành newsMovies
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '10:01',
            style: AppTextStyles.bodyLarge.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'Chào, Angelina ', style: AppTextStyles.headlineLarge),
                const TextSpan(text: '👑', style: TextStyle(fontSize: 32)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Chào mừng trở lại',
            style: AppTextStyles.bodyLarge.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: '🔍 Tìm kiếm',
            hintStyle: AppTextStyles.bodyLarge,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
          style: AppTextStyles.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildNowPlayingSection(BuildContext context, List<Movie> movies) {
    if (movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Now playing',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MovieScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: const Text(
                    'See all >',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFE94560),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Carousel với hiệu ứng ảnh giữa sáng, 2 bên tối
        NowPlayingCarousel(movies: movies),
      ],
    );
  }  Widget _buildComingSoonSection(BuildContext context, List<Movie> movies) {
    if (movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sắp chiếu', style: AppTextStyles.titleLarge),
              SeeAllButton(onTap: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MovieScreen()),
              );}),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MovieCard(movie: movies[index], isNowPlaying: false);
            },
          ),
        ),
      ],
    );
  }

  // SỬA: News section nhận List<Movie>
  Widget _buildNewsSection(List<Movie> movies) {
    if (movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Movie news', style: AppTextStyles.titleLarge),
              SeeAllButton(onTap: () {}),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return NewsCard(movie: movies[index]);  // Truyền movie
            },
          ),
        ),
      ],
    );
  }
}