import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/movie/models/movie_detail.dart';

class MovieInfo extends StatefulWidget {
  const MovieInfo({
    super.key,
    required this.movie,
  });

  final MovieDetail movie;

  @override
  State<MovieInfo> createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {
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
        const Text(
          '2021',
          style: TextStyle(
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
        const Text(
          '148 Minutes',
          style: TextStyle(
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
        const Text(
          'Action',
          style: TextStyle(
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
