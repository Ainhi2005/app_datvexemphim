import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/see_all_button.dart';
import '../../../core/widgets/now_playing_card.dart';
import '../../../core/widgets/movie_card.dart';
import '../../../core/widgets/service_card.dart';
import '../../../core/widgets/news_card.dart';

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

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildNowPlayingSection(provider.nowPlaying),
                  const SizedBox(height: 32),
                  _buildComingSoonSection(provider.comingSoon),
                  const SizedBox(height: 24),
                  _buildServiceSection(),
                  const SizedBox(height: 24),
                  _buildNewsSection(provider.news),
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

  // PHẦN NOW PLAYING VỚI THANH TRƯỢT NGANG
  Widget _buildNowPlayingSection(List<dynamic> movies) {
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
                onTap: () {},
                child: const Text(
                  'See all >',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFE94560),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // SỬA Ở ĐÂY - Tăng chiều cao của SizedBox
        SizedBox(
          height: 520, // Tăng từ 340 lên 620 để đủ chứa card cao 580 + margin
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return NowPlayingCard(
                title: movie.title,
                duration: movie.duration,
                genre: movie.genre,
                rating: movie.rating,
                reviewCount: movie.reviewCount,
                imageUrl: movie.posterUrl,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildComingSoonSection(List<dynamic> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sắp chiếu', style: AppTextStyles.titleLarge),
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
              return MovieCard(movie: movies[index], isNowPlaying: false);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceSection() {
    // Dữ liệu service với ảnh
    final List<Map<String, String>> services = [
      {
        'label': 'Retail',
        'description': '- THEATRE',
        'imageUrl': 'https://iguov8nhvyobj.vcdn.cloud/media/wysiwyg/group-sale/thu_rap.png',
      },
      {
        'label': 'Imax',
        'description': '- THEATRE',
        'imageUrl': 'https://iguov8nhvyobj.vcdn.cloud/media/imax/hight-light-screen-imax.jpg',
      },
      {
        'label': '4DX',
        'description': '- THEATRE',
        'imageUrl': 'https://iguov8nhvyobj.vcdn.cloud/media/wysiwyg/theaters/4dx/1_4dx.png',
      },
      {
        'label': 'Sweetbox',
        'description': '- THEATRE',
        'imageUrl': 'https://iguov8nhvyobj.vcdn.cloud/media/theaters/special/sweetbox/sweetbox-art-3.png',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Service', style: AppTextStyles.titleLarge),
              SeeAllButton(onTap: () {}),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: services.map((service) {
              return ServiceCard(
                label: service['label']!,
                description: service['description']!,
                imageUrl: service['imageUrl']!,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsSection(List<dynamic> news) {
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
        // Thanh trượt ngang cho news
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: news.length,
            itemBuilder: (context, index) {
              return NewsCard(news: news[index]);
            },
          ),
        ),
      ],
    );
  }
}