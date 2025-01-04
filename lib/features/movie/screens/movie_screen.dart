import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/breakpoints.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:moviesplus/features/dashboard/models/movies_response.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/dashboard/services/movie_db_service.dart';
import 'package:moviesplus/features/dashboard/widgets/web/appbar.dart';
import 'package:moviesplus/features/movie/models/movie_credits.dart';
import 'package:moviesplus/features/movie/models/movie_detail.dart';
import 'package:moviesplus/features/movie/models/movie_videos_response.dart';
import 'package:moviesplus/features/movie/widgets/movie_appbar.dart';
import 'package:moviesplus/features/movie/widgets/movie_cast.dart';
import 'package:moviesplus/features/movie/widgets/movie_details.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/providers/video_provider.dart';
import 'package:moviesplus/features/shared/widgets/custom_sliver_builder.dart';
import 'package:moviesplus/features/shared/widgets/movie_item.dart';
import 'package:moviesplus/features/shared/widgets/progress_indicator.dart';
import 'package:moviesplus/generated/l10n.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  bool isLoading = false;
  MovieDetail movieDetail = MovieDetail();
  String heroTag = '';
  List<Cast> _cast = [];
  List<Movie> _similarMovies = [];
  List<Video> _videos = [];
  List<Movie> _recommendationsMovies = [];
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  late int movieId;

  @override
  void initState() {
    movieId = int.tryParse(widget.movieId) ?? 0;
    _tabController = TabController(length: 3, vsync: this);
    getMovie();
    getMovieCredits();
    getSimilarMovies();
    getRecommendationsdMovies();
    getMovieVideos();
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
        isLoading = true;
      });
    }

    try {
      final MovieDetail response = await MovieDbService.getMovieDetail(
        id: movieId,
      );
      setState(() {
        movieDetail = response;
      });
    } catch (e) {
      throw Exception(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  getMovieCredits() async {
    try {
      final MovieCredits response = await MovieDbService.getMovieCredits(
        id: movieId,
      );
      setState(() {
        _cast = response.cast;
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

  getMovieVideos() async {
    try {
      final MovieVideosResponse response = await MovieDbService.getMovieVideos(
        id: movieId,
      );
      setState(() {
        _videos = response.results;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);
    final double maxWidth = screen.size.height * 1.1;
    final videoState = ref.watch(videoProvider);

    List<String> tabs = [
      S.of(context).Similar,
      S.of(context).Recommendations,
      S.of(context).CastAndCrew,
    ];

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CustomProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: kIsWeb,
      appBar: kIsWeb ? const AppbarWeb() : null,
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: videoState,
        ),
        builder: (context, player) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              CustomSliverBuilder(
                maxWidth: maxWidth,
                builder: (context, constraints) {
                  return MovieAppbar(
                    movieDetail: movieDetail,
                    scrollController: _scrollController,
                    heroTag: heroTag,
                    widthScreen: constraints.crossAxisExtent,
                  );
                },
              ),
              CustomSliverBuilder(
                maxWidth: maxWidth,
                padding: EdgeInsets.only(
                  right: horizontalPaddingMobile,
                  left: horizontalPaddingMobile,
                  top: screen.size.width > Breakpoints.md ? 12 : 0,
                ),
                builder: (context, constraints) {
                  return MovieDetails(
                    heroTag: heroTag,
                    movieDetail: movieDetail,
                    widthScreen: constraints.crossAxisExtent,
                    videos: _videos,
                  );
                },
              ),
              CustomSliverBuilder(
                maxWidth: maxWidth,
                builder: (context, constraints) {
                  return SliverAppBar(
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
                          horizontal: horizontalPaddingMobile,
                        ),
                        labelPadding: EdgeInsets.zero,
                        onTap: (value) {
                          setState(() {
                            _tabController.animateTo(value);
                          });
                        },
                        tabAlignment: TabAlignment.start,
                        indicatorColor: AppColors.primaryBlueAccent,
                        overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
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
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 12),
              ),
              if (_tabController.index == 0)
                //** Similar movies */
                CustomSliverBuilder(
                  maxWidth: maxWidth,
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPaddingMobile,
                  ),
                  builder: (context, constraints) {
                    return SliverGrid.builder(
                      itemBuilder: (context, index) {
                        final movie = _similarMovies[index];
                        return MovieItem(movie: movie);
                      },
                      gridDelegate: movieSliverGridDelegate(
                        constraints.crossAxisExtent,
                      ),
                      itemCount: _similarMovies.length,
                    );
                  },
                ),
              if (_tabController.index == 1)
                //** Recommentadions movies */
                CustomSliverBuilder(
                  maxWidth: maxWidth,
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPaddingMobile,
                  ),
                  builder: (context, constraints) {
                    return SliverGrid.builder(
                      itemBuilder: (context, index) {
                        final movie = _recommendationsMovies[index];
                        return MovieItem(movie: movie);
                      },
                      gridDelegate: movieSliverGridDelegate(
                        constraints.crossAxisExtent,
                      ),
                      itemCount: _recommendationsMovies.length,
                    );
                  },
                ),
              if (_tabController.index == 2)
                //** Cast */
                CustomSliverBuilder(
                  maxWidth: maxWidth,
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPaddingMobile,
                  ),
                  builder: (context, constraints) {
                    return MovieCast(cast: _cast);
                  },
                ),
              SliverToBoxAdapter(
                child: Container(
                  height: 32 + screen.padding.bottom,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
