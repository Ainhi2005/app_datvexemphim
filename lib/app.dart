import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/main/screens/main_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(), // CHẠY MAIN SCREEN
    );
  }
}