import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/dashboard/widgets/horizontal_list_movies.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/models/movie_category.dart';
import 'package:moviesplus/features/shared/widgets/poster_image.dart';

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
                left: 16,
                right: 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Movies ',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      height: 19.5 / 16,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  const Text(
                    'Plus',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlueAccent,
                      height: 19.5 / 16,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlueAccent,
                      height: 19.5 / 16,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: const OvalBorder(),
                      minimumSize: const Size(42, 42),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/search.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(bottom: 24),
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
        autoplay: true,
        itemCount: movies.length,
        itemBuilder: (context, index) => _Slide(
          movie: movies[index],
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    );

    return GestureDetector(
      onTap: () {
        context.push('/movie/${movie.id}');
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 0),
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GestureDetector(
            child: PosterImage(
              path: movie.posterPath,
            ),
          ),
        ),
      ),
    );
  }
}
