import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/sizes.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    required this.path,
    this.width = 60,
    this.height = 60,
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
    return ClipOval(
      child: Container(
        color: AppColors.primarySoft,
        child: path != null
            ? Opacity(
                opacity: opacity,
                child: FadeInImage(
                  width: width,
                  height: height,
                  image: NetworkImage(
                    'https://image.tmdb.org/t/p/$fileSize$path',
                  ),
                  fit: BoxFit.cover,
                  placeholder:
                      const AssetImage('assets/images/transparent.png'),
                ),
              )
            : null,
      ),
    );
  }
}
