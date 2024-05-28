import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/movie/models/movie_credits.dart';
import 'package:moviesplus/features/shared/widgets/profile_image.dart';

class MovieCast extends StatefulWidget {
  const MovieCast({
    super.key,
    required this.credits,
  });

  final MovieCredits credits;

  @override
  State<MovieCast> createState() => _MovieCastState();
}

class _MovieCastState extends State<MovieCast> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final Cast cast = widget.credits.cast[index];
          return Row(
            children: [
              ProfileImage(
                path: cast.profilePath,
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
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 24,
          );
        },
        itemCount: widget.credits.cast.length,
      ),
    );
  }
}
