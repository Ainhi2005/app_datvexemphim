import 'package:flutter/foundation.dart'; // Thêm dòng này để dùng kReleaseMode
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';

import 'app.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/movie/providers/movie_provider.dart';
import 'features/movie/providers/showtime_provider.dart';
import 'features/movie/providers/movie_detail_provider.dart';
import 'features/movie/providers/rating_provider.dart';


void main() {
  final authProvider = AuthProvider();
  authProvider.tryAutoLogin();
  runApp(
    DevicePreview(
      // Tự động TẮT khi build release (app thật), BẬT khi chạy debug
      // Nếu bạn muốn tắt hẳn cho cả team lúc code, đổi thành: enabled: false,
      enabled: !kReleaseMode, 
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => MovieProvider()),
          ChangeNotifierProvider(create: (_) => ShowtimeProvider()),
          ChangeNotifierProvider(create: (_) => MovieDetailProvider()),
          ChangeNotifierProvider(create: (_) => RatingProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}