import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/app_colors.dart';

class BackdropImage extends StatelessWidget {
  const BackdropImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.opacity,
  });

  final String? path;
  final double? width;
  final double? height;
  final Animation<double>? opacity;
  @override
  Widget build(BuildContext context) {
    if (path != null) {
      return Image(
        width: width,
        height: height,
        opacity: opacity,
        image: NetworkImage(
          'https://image.tmdb.org/t/p/original$path',
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Container(
              color: AppColors.primarySoft,
            );
          }
        },
        fit: BoxFit.cover,
      );
    }

    return Image(
      width: width,
      height: height,
      opacity: opacity,
      image: const AssetImage('assets/images/no-image-found.png'),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Container(
            color: AppColors.primarySoft,
          );
        }
      },
      fit: BoxFit.cover,
    );
  }
}
