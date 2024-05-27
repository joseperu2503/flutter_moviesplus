import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/dashboard/models/movies_response.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/dashboard/services/movie_db_service.dart';
import 'package:moviesplus/features/shared/models/service_exception.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(moviesProvider.notifier).initData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movieCategories = ref.watch(moviesProvider).movieCategories;
    final screen = MediaQuery.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: screen.padding.top,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Movies Plus+',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      height: 19.5 / 16,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  SizedBox(
                    height: 24,
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
              return HorizonalListMovies(
                movieCategory: movieCategories[index],
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

class HorizonalListMovies extends ConsumerStatefulWidget {
  const HorizonalListMovies({
    super.key,
    required this.movieCategory,
  });

  final MovieCategory movieCategory;

  @override
  HorizonalListMoviesState createState() => HorizonalListMoviesState();
}

class HorizonalListMoviesState extends ConsumerState<HorizonalListMovies> {
  @override
  void initState() {
    getMovies();
    super.initState();
  }

  List<Movie> movies = [];
  int page = 1;
  int totalPages = 1;
  bool loading = false;

  getMovies() async {
    if (page > totalPages || loading) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final MoviesResponse response = await MovieDbService.getMovies(
        path: widget.movieCategory.url,
        page: page,
      );
      setState(() {
        movies = [...movies, ...response.results];
        page = page + 1;
      });
    } on ServiceException catch (e) {
      throw Exception(e);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              Text(
                widget.movieCategory.name,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  height: 19.5 / 16,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final Movie movie = movies[index];
              return SizedBox(
                width: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GestureDetector(
                    child: FadeInImage(
                      height: 220,
                      fit: BoxFit.cover,
                      placeholder:
                          const AssetImage('assets/loaders/bottle-loader.gif'),
                      image: NetworkImage(movie.posterPath),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 10,
              );
            },
            itemCount: movies.length,
          ),
        ),
      ],
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
    getMovies();
    super.initState();
  }

  List<Movie> movies = [];
  int page = 1;
  int totalPages = 1;
  bool loading = false;

  getMovies() async {
    if (page > totalPages || loading) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final MoviesResponse response = await MovieDbService.getMovies(
        path: '/movie/now_playing',
        page: page,
      );
      setState(() {
        movies = [...movies, ...response.results];
        page = page + 1;
      });
    } on ServiceException catch (e) {
      throw Exception(e);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Swiper(
        viewportFraction: 0.6,
        scale: 0.8,
        autoplay: true,
        pagination: const SwiperPagination(
          margin: EdgeInsets.only(top: 0),
          builder: DotSwiperPaginationBuilder(
            activeColor: AppColors.primaryBlueAccent,
            color: AppColors.textDarkGrey,
          ),
        ),
        
        itemCount: movies.length,
        itemBuilder: (context, index) => _Slide(movie: movies[index]),
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
      boxShadow: const [
        BoxShadow(
          color: Colors.black45,
          blurRadius: 10,
          offset: Offset(0, 10),
        )
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GestureDetector(
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
              image: NetworkImage(movie.posterPath),
            ),
          ),
        ),
      ),
    );
  }
}
