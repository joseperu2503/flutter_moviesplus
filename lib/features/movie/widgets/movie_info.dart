import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/movie/models/movie_detail.dart';
import 'package:moviesplus/generated/l10n.dart';

class MovieInfo extends StatelessWidget {
  const MovieInfo({
    super.key,
    required this.movie,
  });
  final MovieDetail movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/schedule.svg',
          width: 18,
          height: 18,
          colorFilter: const ColorFilter.mode(
            AppColors.textGrey,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          movie.releaseDate?.year != null
              ? movie.releaseDate!.year.toString()
              : '',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
            height: 14.63 / 12,
            letterSpacing: 0.12,
            leadingDistribution: TextLeadingDistribution.even,
          ),
        ),
        Container(
          height: 16,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: const VerticalDivider(
            width: 1,
            color: AppColors.textDarkGrey,
          ),
        ),
        SvgPicture.asset(
          'assets/icons/clock.svg',
          width: 18,
          height: 18,
          colorFilter: const ColorFilter.mode(
            AppColors.textGrey,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          movie.runtime != null
              ? '${movie.runtime} ${S.of(context).minutes}'
              : '',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
            height: 14.63 / 12,
            letterSpacing: 0.12,
            leadingDistribution: TextLeadingDistribution.even,
          ),
        ),
        Container(
          height: 16,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: const VerticalDivider(
            width: 1,
            color: AppColors.textDarkGrey,
          ),
        ),
        SvgPicture.asset(
          'assets/icons/movie.svg',
          width: 18,
          height: 18,
          colorFilter: const ColorFilter.mode(
            AppColors.textGrey,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          movie.genres != null && movie.genres!.isNotEmpty
              ? movie.genres![0].name
              : '',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
            height: 14.63 / 12,
            letterSpacing: 0.12,
            leadingDistribution: TextLeadingDistribution.even,
          ),
        ),
      ],
    );
  }
}
