import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/error_view.dart';
import '../widgets/movie_grid.dart';
import '../widgets/movie_tab_bar.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  int _selectedTab = 0;

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
            if (provider.isLoading) return const LoadingIndicator();
            if (provider.error != null) {
              return ErrorView(message: provider.error!, onRetry: provider.fetchMovies);
            }

            return Column(
              children: [
                // Tab Bar
                MovieTabBar(
                  selectedTab: _selectedTab,
                  onTabChanged: (index) {
                    setState(() {
                      _selectedTab = index;
                    });
                  },
                ),
                // Danh sách phim
                Expanded(
                  child: _selectedTab == 0
                      ? MovieGrid(movies: provider.nowPlayingMovies, isNowPlaying: true)
                      : MovieGrid(movies: provider.comingSoonMovies, isNowPlaying: false),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}