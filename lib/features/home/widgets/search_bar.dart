import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/home_provider.dart';
import 'search_delegate.dart';
import 'package:tet/core/l10n/app_localizations.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          final provider = context.read<HomeProvider>();
          final allMovies = [
            ...provider.nowPlaying,
            ...provider.comingSoon,
            ...provider.newsMovies,
          ];
          // Lọc trùng lặp dựa vào id
          final uniqueMovies = {for (var m in allMovies) m.id: m}.values.toList();
          
          showSearch(
            context: context,
            delegate: MovieSearchDelegate(movies: uniqueMovies, hintText: AppLocalizations.of(context)!.search_hint),
          );
        },
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 38, 38, 38), // Slate 800
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF334155), width: 1),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.search_hint,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
