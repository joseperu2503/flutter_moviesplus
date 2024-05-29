import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/features/dashboard/models/genre.dart';
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

  MovieCategory({
    required this.name,
    required this.url,
    this.queryParameters = const {},
  });

  MovieCategory copyWith({
    String? name,
    String? url,
    Map<String, dynamic>? queryParameters,
  }) =>
      MovieCategory(
        name: name ?? this.name,
        url: url ?? this.url,
        queryParameters: queryParameters ?? this.queryParameters,
      );
}
