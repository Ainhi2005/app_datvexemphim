import 'dart:async';

import 'package:flutter/material.dart';
import 'now_playing_card.dart';
import '../../data/models/movie.dart';

class AutoScrollNowPlaying extends StatefulWidget {
  final List<Movie> movies;

  const AutoScrollNowPlaying({super.key, required this.movies});

  @override
  State<AutoScrollNowPlaying> createState() => _AutoScrollNowPlayingState();
}

class _AutoScrollNowPlayingState extends State<AutoScrollNowPlaying> {
  late final ScrollController _scrollController;
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Tự động scroll mỗi 3 giây
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (widget.movies.isNotEmpty) {
        _currentIndex = (_currentIndex + 1) % widget.movies.length;
        _scrollController.animateTo(
          _currentIndex * 216.0, // 200 width + 16 margin
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16),
      itemCount: widget.movies.length,
      itemBuilder: (context, index) {
        final movie = widget.movies[index];
        return NowPlayingCard(
          title: movie.title,
          duration: movie.formattedDuration,
          genre: movie.formattedGenres,
          rating: movie.rating,
          reviewCount: movie.reviewCount,
          imageUrl: movie.posterUrl,
        );
      },
    );
  }
}