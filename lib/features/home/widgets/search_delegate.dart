import 'package:flutter/material.dart';
import '../../../data/models/movie.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import 'package:tet/core/l10n/app_localizations.dart';

class MovieSearchDelegate extends SearchDelegate<Movie?> {
  final List<Movie> movies;
  final String hintText;

  MovieSearchDelegate({required this.movies, required this.hintText}) : super(
    searchFieldLabel: hintText,
    searchFieldStyle: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      scaffoldBackgroundColor: AppColors.background,
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final filteredMovies = movies.where((movie) {
      return movie.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (filteredMovies.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.search_not_found, style: const TextStyle(color: Colors.white70)),
      );
    }

    return ListView.builder(
      itemCount: filteredMovies.length,
      itemBuilder: (context, index) {
        final movie = filteredMovies[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              movie.posterUrl,
              width: 50,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.movie, color: Colors.white54),
            ),
          ),
          title: Text(movie.title, style: AppTextStyles.titleSmall),
          subtitle: Text(movie.formattedGenres, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white60)),
          onTap: () {
            close(context, null);
            Navigator.pushNamed(
              context,
              AppRoutes.movieDetail,
              arguments: movie,
            );
          },
        );
      },
    );
  }
}
