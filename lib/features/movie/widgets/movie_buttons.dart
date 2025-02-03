import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/movie/models/movie_detail.dart';
import 'package:moviesplus/features/movie/models/movie_videos_response.dart';
import 'package:moviesplus/features/shared/providers/video_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:moviesplus/generated/l10n.dart';

class MovieButtons extends ConsumerStatefulWidget {
  const MovieButtons({
    super.key,
    required this.movie,
    required this.videos,
  });

  final MovieDetail movie;
  final List<Video> videos;

  @override
  MovieButtonsState createState() => MovieButtonsState();
}

class MovieButtonsState extends ConsumerState<MovieButtons> {
  shareMovie() async {
    await Share.share(
      '${widget.movie.title} \n\n https://moviesplus.joseperezgil.com/movie/${widget.movie.id}',
    );
  }

  playTrailer() {
    ref.read(videoProvider.notifier).playTrailer(widget.videos.first.key);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.videos.isNotEmpty)
          TextButton(
            onPressed: () {
              playTrailer();
            },
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
                Text(
                  S.of(context).Trailer,
                  style: const TextStyle(
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
        // TextButton(
        //   onPressed: () {},
        //   style: TextButton.styleFrom(
        //     backgroundColor: AppColors.primarySoft,
        //     minimumSize: const Size(48, 48),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(32),
        //     ),
        //     padding: EdgeInsets.zero,
        //   ),
        //   child: SvgPicture.asset(
        //     'assets/icons/download.svg',
        //     width: 24,
        //     height: 24,
        //     colorFilter: const ColorFilter.mode(
        //       AppColors.secondaryOrange,
        //       BlendMode.srcIn,
        //     ),
        //   ),
        // ),
        const SizedBox(
          width: 16,
        ),
        TextButton(
          onPressed: () {
            shareMovie();
          },
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
