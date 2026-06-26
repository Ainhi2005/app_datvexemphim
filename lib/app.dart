// lib/app.dart
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart'; // Thêm dòng này

import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tet/core/l10n/app_localizations.dart' show AppLocalizations;

import 'core/theme/app_theme.dart';
import 'core/provider/locale_provider.dart';
import 'routes/app_routes.dart'; 

class MyApp extends StatelessWidget {
  final bool isAuthenticated;

  const MyApp({super.key, required this.isAuthenticated});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      // --- Thêm 2 dòng này để kết nối với Device Preview ---
      locale: DevicePreview.isEnabled(context) ? DevicePreview.locale(context) : localeProvider.locale,
      builder: DevicePreview.isEnabled(context) ? DevicePreview.appBuilder : null,
      // ---------------------------------------------------
      
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
      ],

      title: 'Movie App',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.main, 
      routes: AppRoutes.routes,
    );
  }
}