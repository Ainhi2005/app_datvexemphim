import 'package:flutter/material.dart';
import '../features/home/screens/home_screen.dart';
import '../features/movie/screens/movie_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String movie = '/movie';

  static Map<String, WidgetBuilder> get routes {
    return {
      home: (context) => const HomeScreen(),
      movie: (context) => const MovieScreen(),
    };
  }
}