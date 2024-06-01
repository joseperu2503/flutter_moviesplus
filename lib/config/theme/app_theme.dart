import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/app_colors.dart';

class AppTheme {
  static ThemeData getTheme() => ThemeData(
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: AppColors.backgroundColor,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(),
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
      );
}
