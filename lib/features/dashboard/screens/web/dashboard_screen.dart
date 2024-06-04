import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/dashboard/widgets/web/horizontal_list_movies.dart';
import 'package:moviesplus/features/movie/widgets/movie_dialog.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/models/movie_category.dart';
import 'package:moviesplus/features/shared/widgets/backdrop_image.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(moviesProvider.notifier).initDashboard();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movieCategories = ref.watch(moviesProvider).movieCategories;
    final screen = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const BackdropDashboard(),
              SliverList.separated(
                itemBuilder: (context, index) {
                  final MovieCategory movieCategory = movieCategories[index];

                  return HorizontalListMoviesWeb(
                    label: movieCategory.name(context),
                    getMovies: () async {
                      await ref.read(moviesProvider.notifier).getMovies(index);
                    },
                    movies: movieCategory.movies,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 32,
                  );
                },
                itemCount: movieCategories.length,
              )
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: 60,
              width: screen.size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundColor,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(
                horizontal: 42,
              ),
              width: screen.size.width,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 20,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 42,
                    height: 42,
                    child: TextButton(
                      onPressed: () {
                        context.go('/search');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/search.svg',
                        width: 28,
                        height: 28,
                        colorFilter: const ColorFilter.mode(
                          AppColors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Positioned(
          //   top: 0,
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Overlay(

          //   ),
          // ),
          // MovieDialog(
          //   movieId: '746036',
          // )
        ],
      ),
    );
  }
}

class BackdropDashboard extends ConsumerStatefulWidget {
  const BackdropDashboard({super.key});

  @override
  BackdropDashboardState createState() => BackdropDashboardState();
}

class BackdropDashboardState extends ConsumerState<BackdropDashboard>
    with AutomaticKeepAliveClientMixin {
  Movie? movie;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ref.listen(moviesProvider, (previous, next) {
      if (movie == null &&
          next.movieCategories.isNotEmpty &&
          next.movieCategories[0].movies.isNotEmpty) {
        setState(() {
          movie = next.movieCategories[0]
              .movies[Random().nextInt(next.movieCategories[0].movies.length)];
        });
        print('path ${movie?.title}');
      }
    });
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
