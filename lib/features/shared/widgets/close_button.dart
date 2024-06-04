import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:go_router/go_router.dart';
import 'package:moviesplus/config/constants/app_colors.dart';

class CustomCloseButton extends ConsumerWidget {
  const CustomCloseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 42,
      height: 42,
      child: TextButton(
        onPressed: () {
          context.pop();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.textBlack.withOpacity(0.7),
        ),
        child: SvgPicture.asset(
          'assets/icons/close.svg',
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
