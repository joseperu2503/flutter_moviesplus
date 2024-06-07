import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/sizes.dart';
import 'package:moviesplus/features/movie/models/movie_credits.dart';
import 'package:moviesplus/features/shared/widgets/profile_image.dart';

class CastItem extends StatelessWidget {
  const CastItem({
    super.key,
    required this.cast,
  });

  final Cast cast;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileImage(
          path: cast.profilePath,
          fileSize: ImageSize.profileW185,
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              cast.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
                height: 17.07 / 14,
                letterSpacing: 0.12,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              cast.character ?? '',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textGrey,
                height: 12.19 / 10,
                letterSpacing: 0.12,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
          ],
        )
      ],
    );
  }
}
