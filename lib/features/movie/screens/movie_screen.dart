import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:moviesplus/features/dashboard/models/movies_response.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/dashboard/services/movie_db_service.dart';
import 'package:moviesplus/features/movie/models/movie_credits.dart';
import 'package:moviesplus/features/movie/models/movie_detail.dart';
import 'package:moviesplus/features/movie/widgets/mobile/movie_appbar_mobile.dart';
import 'package:moviesplus/features/movie/widgets/movie_buttons.dart';
import 'package:moviesplus/features/movie/widgets/movie_cast.dart';
import 'package:moviesplus/features/movie/widgets/movie_info.dart';
import 'package:moviesplus/features/movie/widgets/web/movie_appbar_web.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/widgets/movie_item.dart';
import 'package:moviesplus/features/shared/widgets/progress_indicator.dart';
import 'package:moviesplus/generated/l10n.dart';

class MovieScreen extends ConsumerStatefulWidget {
  const MovieScreen({
    super.key,
    required this.movieId,
  });

  final String movieId;

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  MovieDetail movieDetail = MovieDetail();
  String heroTag = '';
  List<Cast> cast = [];

  List<Movie> _similarMovies = [];
  List<Movie> _recommendationsMovies = [];
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    getMovie();
    getMovieCredits();
    getSimilarMovies();
    getRecommendationsdMovies();
    super.initState();
  }

  getMovie() async {
    final moviesState = ref.read(moviesProvider);
    final Movie? movie = moviesState.temporalMovie;
    if (movie != null && !kIsWeb) {
      setState(() {
        movieDetail = MovieDetail(
          adult: movie.adult,
          backdropPath: movie.backdropPath,
          id: movie.id,
          originalTitle: movie.originalTitle,
          overview: movie.overview,
          popularity: movie.popularity,
          posterPath: movie.posterPath,
          title: movie.title,
          video: movie.video,
          voteAverage: movie.voteAverage,
          voteCount: movie.voteCount,
        );
        heroTag = moviesState.heroTag;
      });
    } else {
      setState(() {
        loading = true;
      });
    }

    try {
      final MovieDetail response = await MovieDbService.getMovieDetail(
        id: int.tryParse(widget.movieId) ?? 0,
      );
      setState(() {
        movieDetail = response;
      });
    } catch (e) {
      throw Exception(e);
    }
    setState(() {
      loading = false;
    });
  }

  getMovieCredits() async {
    try {
      final MovieCredits response = await MovieDbService.getMovieCredits(
        id: int.tryParse(widget.movieId) ?? 0,
      );
      setState(() {
        cast = response.cast;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  getSimilarMovies() async {
    try {
      final MoviesResponse response = await MovieDbService.getMovies(
        path: '/movie/${widget.movieId}/similar',
      );
      setState(() {
        _similarMovies = response.results;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  getRecommendationsdMovies() async {
    try {
      final MoviesResponse response = await MovieDbService.getMovies(
        path: '/movie/${widget.movieId}/recommendations',
      );
      setState(() {
        _recommendationsMovies = response.results;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    List<String> tabs = [
      S.of(context).CastAndCrew,
      S.of(context).Recommendations,
      S.of(context).Similar,
    ];

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CustomProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        anchor: 0,
        slivers: [
          if (!kIsWeb)
            MovieAppbarMobile(
              movieDetail: movieDetail,
              scrollController: _scrollController,
              heroTag: heroTag,
            ),
          if (kIsWeb)
            MovieAppbarWeb(
              movieDetail: movieDetail,
              heroTag: heroTag,
            ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MovieInfo(movie: movieDetail),
                  const SizedBox(
                    height: 24,
                  ),
                  MovieButtons(movie: movieDetail),
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
          ),
          SliverAppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.backgroundColor,
            pinned: true,
            toolbarHeight: 70,
            primary: false,
            flexibleSpace: Container(
              padding: const EdgeInsets.only(
                bottom: 12,
              ),
              height: 70,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                labelPadding: EdgeInsets.zero,
                onTap: (value) {
                  setState(() {
                    _tabController.animateTo(value);
                  });
                },
                tabAlignment: TabAlignment.start,
                indicatorColor: AppColors.primaryBlueAccent,
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return AppColors.white.withOpacity(0.3);
                  }

                  return null;
                }),
                dividerColor: AppColors.textDarkGrey,
                dividerHeight: 2,
                tabs: tabs.map((tab) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    child: Text(
                      tab,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                        height: 19.5 / 16,
                        letterSpacing: 0.12,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),
          if (_tabController.index == 0)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: MovieCast(cast: cast),
            ),
          if (_tabController.index == 1)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid.builder(
                itemBuilder: (context, index) {
                  final movie = _similarMovies[index];
                  return MovieItem(movie: movie);
                },
                gridDelegate: movieSliverGridDelegate(context),
                itemCount: _similarMovies.length,
              ),
            ),
          if (_tabController.index == 2)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid.builder(
                itemBuilder: (context, index) {
                  final movie = _recommendationsMovies[index];
                  return MovieItem(movie: movie);
                },
                gridDelegate: movieSliverGridDelegate(context),
                itemCount: _recommendationsMovies.length,
              ),
            ),
          SliverToBoxAdapter(
            child: Container(
              height: 20 + screen.padding.bottom,
            ),
          )
        ],
      ),
    );
  }
}
