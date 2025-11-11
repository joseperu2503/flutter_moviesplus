import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/features/dashboard/models/genre.dart';
import 'package:moviesplus/features/dashboard/models/movies_response.dart';
import 'package:moviesplus/features/dashboard/services/movie_db_service.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/models/movie_category.dart';
import 'package:moviesplus/generated/l10n.dart';

final moviesProvider =
    StateNotifierProvider<MoviesNotifier, MoviesState>((ref) {
  return MoviesNotifier(ref);
});

class MoviesNotifier extends StateNotifier<MoviesState> {
  MoviesNotifier(this.ref) : super(MoviesState());
  final StateNotifierProviderRef ref;

  initDashboard() async {
    state = state.copyWith(
      movieCategories: {...initMovieCategories},
    );

    await getMovieGenres();
  }

  getMovieGenres() async {
    try {
      final List<Genre> genres = await MovieDbService.getMovieGenres();
      for (var genre in genres) {
        if (genre.name == null) continue;

        Map<String, MovieCategory> newMovieCategories = {
          ...state.movieCategories
        };

        if (newMovieCategories[genre.id.toString()] == null) {
          newMovieCategories[genre.id.toString()] = MovieCategory(
            name: (context) {
              return genre.name ?? '';
            },
            url: '/discover/movie',
            queryParameters: {
              "with_genres": genre.id,
            },
            seeMoreUrl: '/genre/${genre.id}',
          );
          state = state.copyWith(
            movieCategories: newMovieCategories,
          );
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  getMovies(String key) async {
    MovieCategory? movieCategory = getMovieCategory(key: key);
    if (movieCategory == null) return;

    if (movieCategory.page > movieCategory.totalPages ||
        movieCategory.loading) {
      return;
    }

    setMovieCategory(key: key, loading: true);

    try {
      final MoviesResponse response = await MovieDbService.getMovies(
        path: movieCategory.url,
        page: movieCategory.page,
        queryParameters: movieCategory.queryParameters,
      );

      setMovieCategory(
        key: key,
        movies: [...movieCategory.movies, ...response.results],
        page: movieCategory.page + 1,
        totalPages: response.totalPages,
      );
    } catch (e) {
      throw Exception(e);
    }
    setMovieCategory(key: key, loading: false);
  }

  MovieCategory? getMovieCategory({
    required String key,
  }) {
    return state.movieCategories[key];
  }

  void setMovieCategory({
    required String key,
    List<Movie>? movies,
    int? page,
    int? totalPages,
    bool? loading,
  }) {
    MovieCategory? movieCategory = getMovieCategory(key: key);
    if (movieCategory == null) return;
    movieCategory = movieCategory.copyWith(
      loading: loading,
      totalPages: totalPages,
      page: page,
      movies: movies,
    );
    Map<String, MovieCategory> newMovieCategories = {...state.movieCategories};
    newMovieCategories[key] = movieCategory;

    state = state.copyWith(
      movieCategories: newMovieCategories,
    );
  }

  setTemporalMovie(Movie temporalMovie) {
    state = state.copyWith(
      temporalMovie: temporalMovie,
    );
  }

  setHeroTag(String heroTag) {
    state = state.copyWith(
      heroTag: heroTag,
    );
  }
}

class MoviesState {
  final Map<String, MovieCategory> movieCategories;
  final List<Genre> movieGenres;
  final Movie? temporalMovie;
  final String heroTag;

  MoviesState({
    this.movieCategories = const {},
    this.movieGenres = const [],
    this.temporalMovie,
    this.heroTag = '',
  });

  MoviesState copyWith({
    Map<String, MovieCategory>? movieCategories,
    List<Genre>? movieGenres,
    Movie? temporalMovie,
    String? heroTag,
  }) =>
      MoviesState(
        movieCategories: movieCategories ?? this.movieCategories,
        movieGenres: movieGenres ?? this.movieGenres,
        temporalMovie: temporalMovie ?? this.temporalMovie,
        heroTag: heroTag ?? this.heroTag,
      );
}

final Map<String, MovieCategory> initMovieCategories = {
  'now-playing': MovieCategory(
    name: (context) {
      return S.of(context).nowPlaying;
    },
    url: '/movie/now_playing',
    seeMoreUrl: '/movies/now-playing',
  ),
  'popular': MovieCategory(
    name: (context) {
      return S.of(context).popular;
    },
    url: '/movie/popular',
    seeMoreUrl: '/movies/popular',
  ),
  'top-rated': MovieCategory(
    name: (context) {
      return S.of(context).topRated;
    },
    url: '/movie/top_rated',
    seeMoreUrl: '/movies/top-rated',
  ),
  'upcoming': MovieCategory(
    name: (context) {
      return S.of(context).upcoming;
    },
    url: '/movie/upcoming',
    queryParameters: {
      'region': 'us',
    },
    seeMoreUrl: '/movies/upcoming',
  ),
};
