import 'package:flutter/material.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/news_card.dart';
import '../../../data/models/movie.dart';
import 'package:tet/core/l10n/app_localizations.dart';

class NewsSection extends StatelessWidget {
  final List<Movie> movies;

  const NewsSection({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: AppLocalizations.of(context)!.home_movie_news, showSeeAll: false),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return NewsCard(movie: movies[index]);
            },
          ),
        ),
      ],
    );
  }
}