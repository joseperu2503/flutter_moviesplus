import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/sizes.dart';

class MovieImage extends StatelessWidget {
  const MovieImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.opacity = 1,
    this.fileSize = ImageSize.original,
  });

  final String? path;
  final double? width;
  final double? height;
  final double opacity;
  final String fileSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: AppColors.primarySoft,
      child: Stack(
        children: [
          SizedBox(
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/logo.svg',
                width: 52,
                height: 52,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryDark,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          if (path != null)
            Opacity(
              opacity: opacity,
              child: FadeInImage(
                width: width,
                height: height,
                image: NetworkImage(
                  'https://image.tmdb.org/t/p/$fileSize$path',
                ),
                fit: BoxFit.cover,
                placeholder: const AssetImage('assets/images/transparent.png'),
              ),
            ),
        ],
      ),
    );
  }
}
