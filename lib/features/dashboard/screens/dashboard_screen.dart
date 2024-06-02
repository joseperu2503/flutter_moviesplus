import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/dashboard/widgets/horizontal_list_movies.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/models/movie_category.dart';
import 'package:moviesplus/features/shared/widgets/poster_image.dart';
import 'package:uuid/uuid.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(moviesProvider.notifier).getMovieGenres();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movieCategories = ref.watch(moviesProvider).movieCategories;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            titleSpacing: 0,
            backgroundColor: AppColors.backgroundColor,
            scrolledUnderElevation: 0,
            pinned: true,
            title: Container(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 18,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(top: 20, bottom: 24),
              child: const SwiperMovies(),
            ),
          ),
          SliverList.separated(
            itemBuilder: (context, index) {
              final MovieCategory movieCategory = movieCategories[index];
              return HorizonalListMovies(
                label: movieCategory.name,
                getMovies: () async {
                  ref.read(moviesProvider.notifier).getMovies(index);
                },
                movies: movieCategory.movies,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 24,
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
    List<Movie> movies = ref.watch(moviesProvider).movieCategories[1].movies;
    if (movies.length >= 5) {
      movies = movies.sublist(0, 5);
    }
    return SizedBox(
      height: 400,
      child: Swiper(
        viewportFraction: 0.6,
        scale: 0.8,
        autoplay: movies.isNotEmpty,
        itemCount: movies.length,
        itemBuilder: (context, index) => _Slide(
          movie: movies[index],
        ),
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
          padding: const EdgeInsets.only(bottom: 0),
          decoration: decoration,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GestureDetector(
              child: PosterImage(
                path: widget.movie.posterPath,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
