import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/app_colors.dart';

class CustomProgressIndicator extends ConsumerWidget {
  const CustomProgressIndicator({
    super.key,
    this.size = 32,
    this.strokeWidth = 4,
  });

  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TargetPlatform platform = defaultTargetPlatform;

    bool isIos =
        platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;

    return SizedBox(
      width: size,
      height: size,
      child: isIos
          ? CupertinoActivityIndicator(
              radius: size / 2,
              color: AppColors.white,
            )
          : CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: strokeWidth,
            ),
    );
  }
}
