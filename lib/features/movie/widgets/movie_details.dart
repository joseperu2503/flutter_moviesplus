import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/breakpoints.dart';
import 'package:moviesplus/config/constants/sizes.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:moviesplus/features/movie/models/movie_detail.dart';
import 'package:moviesplus/features/movie/models/movie_videos_response.dart';
import 'package:moviesplus/features/movie/widgets/movie_buttons.dart';
import 'package:moviesplus/features/movie/widgets/movie_info.dart';
import 'package:moviesplus/features/shared/widgets/movie_image.dart';

class MovieDetails extends StatelessWidget {
  const MovieDetails({
    super.key,
    required this.widthScreen,
    required this.movieDetail,
    required this.heroTag,
    required this.videos,
  });

  final double widthScreen;
  final MovieDetail movieDetail;
  final String heroTag;
  final List<Video> videos;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widthScreen > Breakpoints.md)
            Container(
              height: 240,
              margin: const EdgeInsets.only(
                right: 24,
              ),
              child: Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: posterAspectRatio,
                    child: MovieImage(
                      path: movieDetail.posterPath,
                      fileSize: ImageSize.posterW500,
                    ),
                  ),
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widthScreen > Breakpoints.md)
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Text(
                      movieDetail.title ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ),
                MovieInfo(movie: movieDetail),
                const SizedBox(
                  height: 24,
                ),
                MovieButtons(
                  movie: movieDetail,
                  videos: videos,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  movieDetail.overview ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white,
                    height: 17.07 / 14,
                    letterSpacing: 0.12,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
