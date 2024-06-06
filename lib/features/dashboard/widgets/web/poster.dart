import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/widgets/backdrop_image.dart';

class PosterDashboard extends ConsumerStatefulWidget {
  const PosterDashboard({super.key});

  @override
  BackdropDashboardState createState() => BackdropDashboardState();
}

class BackdropDashboardState extends ConsumerState<PosterDashboard>
    with AutomaticKeepAliveClientMixin {
  Movie? movie;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    //TODO: CORREGIR
    // ref.listen(moviesProvider, (previous, next) {
    //   if (movie == null &&
    //       next.movieCategories.isNotEmpty &&
    //       next.movieCategories[0].movies.isNotEmpty) {
    //     setState(() {
    //       movie = next.movieCategories[0]
    //           .movies[Random().nextInt(next.movieCategories[0].movies.length)];
    //     });
    //   }
    // });
    final screen = MediaQuery.of(context);

    return SliverToBoxAdapter(
      child: (movie != null)
          ? Container(
              padding: const EdgeInsets.only(
                bottom: 32,
              ),
              child: Stack(
                children: [
                  BackdropImage(
                    path: movie?.backdropPath,
                  ),
                  Positioned(
                    bottom: 0,
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
              ),
            )
          : Container(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
