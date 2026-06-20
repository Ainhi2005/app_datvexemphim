import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/now_playing_carousel.dart';
import '../../../core/widgets/horizontal_movie_list.dart';
import '../widgets/home_header.dart';
import '../widgets/search_bar.dart';
import '../widgets/news_section.dart';
import '../../movie/screens/movie_screen.dart';
import '../../../data/models/movie.dart';
import 'package:tet/core/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) return const LoadingIndicator();
            if (provider.error != null) {
              return ErrorView(
                message: provider.error!,
                onRetry: provider.fetchHomeData,
              );
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const HomeHeader(),
                        const SizedBox(height: 20),
                        const HomeSearchBar(),
                        const SizedBox(height: 24),
                        _buildNowPlayingSection(context, provider.nowPlaying),
                        const SizedBox(height: 32),
                        _buildComingSoonSection(context, provider.comingSoon),
                        const SizedBox(height: 24),
                        NewsSection(movies: provider.newsMovies),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNowPlayingSection(BuildContext context, List<Movie> movies) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SectionHeader(
          title: AppLocalizations.of(context)!.home_now_playing,
          onSeeAll: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MovieScreen()),
          ),
        ),
        const SizedBox(height: 16),
        NowPlayingCarousel(
          movies: movies,
          onPageChanged: (_) {},
        ),
      ],
    );
  }

  Widget _buildComingSoonSection(BuildContext context, List<Movie> movies) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SectionHeader(
          title: AppLocalizations.of(context)!.home_coming_soon,
          onSeeAll: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MovieScreen()),
          ),
        ),
        const SizedBox(height: 16),
        HorizontalMovieList(movies: movies, isNowPlaying: false),
      ],
    );
  }
}
