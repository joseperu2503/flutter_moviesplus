import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/app_colors.dart';

class AppTheme {
  static ThemeData getTheme() => ThemeData(
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: AppColors.backgroundColor,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(),
        primaryColor: AppColors.backgroundColor,
        bottomSheetTheme: const BottomSheetThemeData(
          modalBackgroundColor: Colors.white,
          showDragHandle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textDarkGrey,
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.primaryBlueAccent,
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: kIsWeb
              ? {
                  for (final platform in TargetPlatform.values)
                    platform: const FadeTransitionBuilder(),
                }
              : {
                  TargetPlatform.macOS: const CupertinoPageTransitionsBuilder(),
                  TargetPlatform.android: const ZoomPageTransitionsBuilder(),
                  TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
                },
        ),
      );
}

class FadeTransitionBuilder extends PageTransitionsBuilder {
  const FadeTransitionBuilder();
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
