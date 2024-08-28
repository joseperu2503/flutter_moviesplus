import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/breakpoints.dart';
import 'package:moviesplus/config/constants/sizes.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/dashboard/widgets/mobile/horizontal_list_movies.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/models/movie_category.dart';
import 'package:moviesplus/features/shared/widgets/movie_image.dart';
import 'package:uuid/uuid.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(moviesProvider.notifier).initDashboard();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movieCategories = ref.watch(moviesProvider).movieCategories;
    final List<MapEntry<String, MovieCategory>> categoryList =
        movieCategories.entries.toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            titleSpacing: 0,
            backgroundColor: Colors.transparent,
            scrolledUnderElevation: 0,
            pinned: true,
            flexibleSpace: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: AppColors.backgroundColor.withOpacity(0.5),
                  child: SafeArea(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.only(
                        left: horizontalPaddingMobile,
                        right: horizontalPaddingMobile,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              child: const SwiperMovies(),
            ),
          ),
          SliverList.separated(
            itemBuilder: (context, index) {
              final MovieCategory movieCategory = categoryList[index].value;
              final String key = categoryList[index].key;

              return HorizonalListMovies(
                key: PageStorageKey(
                  '${movieCategory.name(context)}${Localizations.localeOf(context)}',
                ),
                label: movieCategory.name(context),
                getMovies: () async {
                  await ref.read(moviesProvider.notifier).getMovies(key);
                },
                movies: movieCategory.movies,
                seeMoreUrl: movieCategory.seeMoreUrl,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 12,
              );
            },
            itemCount: movieCategories.length,
          )
        ],
      ),
    );
  }
}

class SwiperMovies extends ConsumerStatefulWidget {
  const SwiperMovies({
    super.key,
  });

  @override
  SwiperMoviesState createState() => SwiperMoviesState();
}

class SwiperMoviesState extends ConsumerState<SwiperMovies> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    final double height = screen.size.width > Breakpoints.md
        ? (screen.size.width - horizontalPaddingMobile * 2) * 0.5
        : screen.size.width;

    final double viewportFraction = screen.size.width > Breakpoints.md
        ? (screen.size.width - horizontalPaddingMobile * 2) / screen.size.width
        : height * posterAspectRatio / screen.size.width;

    List<Movie> movies = [];
    final movieCategories = ref.watch(moviesProvider).movieCategories;
    if (movieCategories['popular'] != null) {
      movies = movieCategories['popular']!.movies;
    }
    if (movies.length >= 5) {
      movies = movies.sublist(0, 5);
    }
    return SizedBox(
      height: height,
      child: Swiper(
        viewportFraction: viewportFraction,
        scale: 0.8,
        autoplay: movies.isNotEmpty,
        itemCount: movies.length,
        itemBuilder: (context, index) => _Slide(
          movie: movies[index],
        ),
        autoplayDelay: 5000,
      ),
    );
  }
}

class _Slide extends ConsumerStatefulWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  SlideState createState() => SlideState();
}

class SlideState extends ConsumerState<_Slide> {
  String tag = const Uuid().v4();

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    );

    return Hero(
      tag: '${widget.movie.id}$tag',
      child: GestureDetector(
        onTap: () {
          ref
              .read(moviesProvider.notifier)
              .setHeroTag('${widget.movie.id}$tag');
          ref.read(moviesProvider.notifier).setTemporalMovie(widget.movie);
          context.push('/movie/${widget.movie.id}');
        },
        child: Container(
          decoration: decoration,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GestureDetector(
              child: MovieImage(
                height: double.infinity,
                width: double.infinity,
                path: screen.size.width > Breakpoints.md
                    ? widget.movie.backdropPath
                    : widget.movie.posterPath,
                fileSize: screen.size.width > Breakpoints.md
                    ? ImageSize.original
                    : ImageSize.posterW500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
