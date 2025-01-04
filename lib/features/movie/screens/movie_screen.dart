import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/breakpoints.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:moviesplus/features/dashboard/models/movies_response.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/dashboard/services/movie_db_service.dart';
import 'package:moviesplus/features/dashboard/widgets/web/appbar.dart';
import 'package:moviesplus/features/movie/models/movie_credits.dart';
import 'package:moviesplus/features/movie/models/movie_detail.dart';
import 'package:moviesplus/features/movie/models/movie_videos_response.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/providers/video_provider.dart';
import 'package:moviesplus/features/shared/widgets/custom_sliver_builder.dart';
import 'package:moviesplus/features/shared/widgets/movie_item.dart';
import 'package:moviesplus/features/shared/widgets/progress_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:moviesplus/features/movie/widgets/widgets.dart';

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
  bool _isLoading = false;
  MovieDetail movieDetail = MovieDetail();
  String heroTag = '';
  List<Cast> _cast = [];
  List<Movie> _similarMovies = [];
  List<Video> _videos = [];
  List<Movie> _recommendationsMovies = [];
  final ScrollController _scrollController = ScrollController();

  late int movieId;

  @override
  void initState() {
    super.initState();

    movieId = int.tryParse(widget.movieId) ?? 0;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Ejecutar todas las peticiones y esperar a que terminen
      await Future.wait([
        getMovie(),
        getMovieCredits(),
        getSimilarMovies(),
        getRecommendationsdMovies(),
        getMovieVideos(),
      ]);
    });
  }

  Future<void> getMovie() async {
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
        _isLoading = true;
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
      _isLoading = false;
    });
  }

  Future<void> getMovieCredits() async {
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

  Future<void> getSimilarMovies() async {
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

  Future<void> getRecommendationsdMovies() async {
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

  Future<void> getMovieVideos() async {
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

    if (_isLoading) {
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
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    MovieCast(cast: _cast),
                    if (_similarMovies.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: SimilarMovies(movies: _similarMovies),
                      )
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPaddingMobile,
                      ),
                      child: Text(
                        'Recommendations',
                        style: Styles.subtitle,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
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
