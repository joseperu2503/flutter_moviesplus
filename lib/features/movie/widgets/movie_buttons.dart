import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moviesplus/config/constants/app_colors.dart';

class MovieButtons extends StatefulWidget {
  const MovieButtons({
    super.key,
  });

  @override
  State<MovieButtons> createState() => _MovieButtonsState();
}

class _MovieButtonsState extends State<MovieButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: AppColors.secondaryOrange,
            minimumSize: const Size(115, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/play.svg',
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'Play',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  height: 19.5 / 16,
                  letterSpacing: 0.12,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primarySoft,
            minimumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            padding: EdgeInsets.zero,
          ),
          child: SvgPicture.asset(
            'assets/icons/download.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.secondaryOrange,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primarySoft,
            minimumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            padding: EdgeInsets.zero,
          ),
          child: SvgPicture.asset(
            'assets/icons/share.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.primaryBlueAccent,
              BlendMode.srcIn,
            ),
          ),
        )
      ],
    );
  }
}
