import 'package:flutter/material.dart';
import 'package:moviesplus/config/router/app_router.dart';
import 'package:moviesplus/config/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
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
