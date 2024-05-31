import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/features/dashboard/models/genre.dart';
import 'package:moviesplus/features/dashboard/models/movies_response.dart';
import 'package:moviesplus/features/dashboard/services/movie_db_service.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/models/movie_category.dart';

final moviesProvider =
    StateNotifierProvider<MoviesNotifier, MoviesState>((ref) {
  return MoviesNotifier(ref);
});

class MoviesNotifier extends StateNotifier<MoviesState> {
  MoviesNotifier(this.ref) : super(MoviesState());
  final StateNotifierProviderRef ref;

  initData() {
    state = state.copyWith(
      movieCategories: [
        MovieCategory(
          name: 'Now Playing',
          url: '/movie/now_playing',
        ),
        MovieCategory(
          name: 'Popular',
          url: '/movie/popular',
        ),
        MovieCategory(
          name: 'Top Rated',
          url: '/movie/top_rated',
        ),
        MovieCategory(
          name: 'Upcoming',
          url: '/movie/upcoming',
        ),
      ],
    );
  }

  getMovieGenres() async {
    try {
      final genres = await MovieDbService.getMovieGenres();
      state = state.copyWith(
        movieCategories: [
          ...state.movieCategories,
          ...genres.map(
            (genre) => MovieCategory(
              name: genre.name,
              url: '/discover/movie',
              queryParameters: {
                "with_genres": genre.id,
              },
            ),
          )
        ],
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  getMovies(int index) async {
    MovieCategory movieCategory = getMovieCategory(index: index);

    if (movieCategory.page > movieCategory.totalPages ||
        movieCategory.loading) {
      return;
    }

    setMovieCategory(index: index, loading: true);

    try {
      final MoviesResponse response = await MovieDbService.getMovies(
        path: movieCategory.url,
        page: movieCategory.page,
        queryParameters: movieCategory.queryParameters,
      );

      setMovieCategory(
        index: index,
        movies: [...movieCategory.movies, ...response.results],
        page: movieCategory.page + 1,
        totalPages: response.totalPages,
      );
    } catch (e) {
      throw Exception(e);
    }
    setMovieCategory(index: index, loading: false);
  }

  MovieCategory getMovieCategory({
    required int index,
  }) {
    return state.movieCategories[index];
  }

  void setMovieCategory({
    required int index,
    List<Movie>? movies,
    int? page,
    int? totalPages,
    bool? loading,
  }) {
    MovieCategory movieCategory = state.movieCategories[index];
    movieCategory = movieCategory.copyWith(
      loading: loading,
      totalPages: totalPages,
      page: page,
      movies: movies,
    );
    List<MovieCategory> newMovieCategories = [...state.movieCategories];
    newMovieCategories[index] = movieCategory;

    state = state.copyWith(
      movieCategories: newMovieCategories,
    );
  }
}

class MoviesState {
  final List<MovieCategory> movieCategories;
  final List<Genre> movieGenres;

  MoviesState({
    this.movieCategories = const [],
    this.movieGenres = const [],
  });

  MoviesState copyWith({
    List<MovieCategory>? movieCategories,
    List<Genre>? movieGenres,
  }) =>
      MoviesState(
        movieCategories: movieCategories ?? this.movieCategories,
        movieGenres: movieGenres ?? this.movieGenres,
      );
}
