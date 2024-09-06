import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/widgets/movie_image.dart';

class PosterDashboard extends ConsumerStatefulWidget {
  const PosterDashboard({super.key});

  @override
  BackdropDashboardState createState() => BackdropDashboardState();
}

class BackdropDashboardState extends ConsumerState<PosterDashboard>
    with AutomaticKeepAliveClientMixin {
  Movie? movie;

  setMovie() {
    final movieCategories = ref.read(moviesProvider).movieCategories;
    if (movie == null &&
        movieCategories['popular'] != null &&
        movieCategories['popular']!.movies.isNotEmpty) {
      setState(() {
        movie = movieCategories['popular']!.movies[
            Random().nextInt(movieCategories['popular']!.movies.length)];
      });
    }
  }

  @override
  void initState() {
    setMovie();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ref.listen(moviesProvider, (previous, next) {
      setMovie();
    });
    final screen = MediaQuery.of(context);

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(
          bottom: 32,
        ),
        child: (movie != null)
            ? Stack(
                children: [
                  MovieImage(
                    width: screen.size.width,
                    height: screen.size.width * 0.5,
                    path: movie?.backdropPath,
                  ),
                  Positioned(
                    bottom: -5,
                    left: 0,
                    child: Container(
                      height: 200,
                      width: screen.size.width,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.backgroundColor,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.only(
                        bottom: 40,
                        left: 42,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie!.title,
                            style: const TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                              height: 1,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 800,
                            ),
                            child: Text(
                              movie!.overview,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textWhiteGrey,
                                height: 1,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : SizedBox(
                width: screen.size.width,
                height: screen.size.width * 0.5,
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
