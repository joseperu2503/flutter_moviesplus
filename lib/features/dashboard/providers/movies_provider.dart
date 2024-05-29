import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/features/dashboard/models/genre.dart';
import 'package:moviesplus/features/dashboard/models/movies_response.dart';
import 'package:moviesplus/features/dashboard/services/movie_db_service.dart';

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

    if (movieCategory.page > movieCategory.page || movieCategory.loading) {
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

class MovieCategory {
  final String name;
  final String url;
  final Map<String, dynamic> queryParameters;
  final List<Movie> movies;
  final int page;
  final int totalPages;
  final bool loading;

  MovieCategory({
    required this.name,
    required this.url,
    this.queryParameters = const {},
    this.movies = const [],
    this.page = 1,
    this.totalPages = 1,
    this.loading = false,
  });

  MovieCategory copyWith({
    String? name,
    String? url,
    Map<String, dynamic>? queryParameters,
    List<Movie>? movies,
    int? page,
    int? totalPages,
    bool? loading,
  }) =>
      MovieCategory(
        name: name ?? this.name,
        url: url ?? this.url,
        queryParameters: queryParameters ?? this.queryParameters,
        movies: movies ?? this.movies,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        loading: loading ?? this.loading,
      );
}
