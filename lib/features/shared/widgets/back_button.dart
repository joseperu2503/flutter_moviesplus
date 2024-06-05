import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:go_router/go_router.dart';
import 'package:moviesplus/config/constants/app_colors.dart';

class CustomBackButton extends ConsumerWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 42,
      height: 42,
      child: TextButton(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: SvgPicture.asset(
          kIsWeb || Platform.isAndroid
              ? 'assets/icons/arrow_back_material.svg'
              : 'assets/icons/arrow_back_ios.svg',
          width: 28,
          height: 28,
          colorFilter: const ColorFilter.mode(
            AppColors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
