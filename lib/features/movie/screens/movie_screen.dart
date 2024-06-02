import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/dashboard/services/movie_db_service.dart';
import 'package:moviesplus/features/dashboard/widgets/temporal_horizontal_list_movies.dart';
import 'package:moviesplus/features/movie/models/movie_credits.dart';
import 'package:moviesplus/features/movie/models/movie_detail.dart';
import 'package:moviesplus/features/movie/widgets/movie_buttons.dart';
import 'package:moviesplus/features/movie/widgets/movie_cast.dart';
import 'package:moviesplus/features/movie/widgets/movie_info.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/models/movie_category.dart';
import 'package:moviesplus/features/shared/widgets/back_button.dart';
import 'package:moviesplus/features/shared/widgets/poster_image.dart';
import 'package:moviesplus/features/shared/widgets/progress_indicator.dart';
import 'package:moviesplus/generated/l10n.dart';

class MovieScreen extends ConsumerStatefulWidget {
  const MovieScreen({
    super.key,
    required this.movieId,
  });

  final int movieId;

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  bool loading = false;
  MovieDetail? movieDetail;
  String heroTag = '';
  MovieCredits? credits;
  double top = 0;
  double width = 205;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    getMovie();
    getMovieCredits();
    scrollListener();
    super.initState();
  }

  getMovie() async {
    final moviesState = ref.read(moviesProvider);
    final Movie? movie = moviesState.temporalMovie;

    if (movie != null) {
      setState(() {
        movieDetail = MovieDetail(
          adult: movie.adult,
          backdropPath: movie.backdropPath,
          id: movie.id,
          originalTitle: movie.originalTitle,
          overview: movie.overview,
          popularity: movie.popularity,
          posterPath: movie.posterPath,
          releaseDate: movie.releaseDate,
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
        id: widget.movieId,
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
        id: widget.movieId,
      );
      setState(() {
        credits = response;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  scrollListener() {
    scrollController.addListener(() {
      final screen = MediaQuery.of(context);

      setState(() {
        if (scrollController.offset < 0) {
          top = screen.padding.top + 60;
          width = 205;
        } else if (scrollController.offset < screen.padding.top + 60) {
          top = screen.padding.top + 60 - scrollController.offset;
          width = 205 +
              (screen.size.width - 205) *
                  (scrollController.offset) /
                  (screen.padding.top + 60);
        } else {
          top = 0;
          width = screen.size.width;
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screen = MediaQuery.of(context);
    top = screen.padding.top + 60;
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    if (movieDetail == null) {
      return const Scaffold(
        body: Center(
          child: CustomProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                titleSpacing: 0,
                toolbarHeight: 42,
                title: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: const Row(
                    children: [
                      CustomBackButton(),
                      SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                ),
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                pinned: true,
                backgroundColor: AppColors.backgroundColor,
                expandedHeight: 450,
                collapsedHeight: 200,
                flexibleSpace: Stack(
                  children: [
                    PosterImage(
                      path: movieDetail!.posterPath,
                      height: 550,
                      width: double.infinity,
                      opacity: const AlwaysStoppedAnimation(0.4),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0, 1],
                          colors: [
                            AppColors.backgroundColor.withOpacity(0.2),
                            AppColors.backgroundColor,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: top,
                      child: Container(
                        width: screen.size.width,
                        alignment: Alignment.topCenter,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Hero(
                            tag: heroTag,
                            child: Material(
                              child: PosterImage(
                                path: movieDetail!.posterPath,
                                width: width,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 80,
                        width: screen.size.width,
                        padding: const EdgeInsets.only(
                          left: 24,
                          bottom: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0, 1],
                            colors: [
                              AppColors.backgroundColor.withOpacity(0),
                              AppColors.backgroundColor,
                            ],
                          ),
                        ),
                        // child: MovieInfo(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                movieDetail!.title ?? '',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MovieInfo(movie: movieDetail!),
                      const SizedBox(
                        height: 24,
                      ),
                      const MovieButtons(),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        movieDetail!.overview ?? '',
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
                      Text(
                        S.of(context).CastAndCrew,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                          height: 19.5 / 16,
                          letterSpacing: 0.12,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (credits != null) MovieCast(credits: credits!),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    TemporalHorizonalListMovies(
                      movieCategory: MovieCategory(
                        name: (context) {
                          return S.of(context).Recommendations;
                        },
                        url: '/movie/${movieDetail!.id}/recommendations',
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TemporalHorizonalListMovies(
                      movieCategory: MovieCategory(
                        name: (context) {
                          return S.of(context).Similar;
                        },
                        url: '/movie/${movieDetail!.id}/similar',
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 40 + screen.padding.bottom,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
