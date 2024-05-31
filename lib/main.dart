import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/environment.dart';
import 'package:moviesplus/config/router/app_router.dart';
import 'package:moviesplus/config/theme/app_theme.dart';

void main() async {
  await Environment.initEnvironment();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.backgroundColor,
    ),
  );

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Movies Plus',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.getTheme(),
    );
  }
}
