import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}

class MoviesState {
  final List<MovieCategory> movieCategories;

  MoviesState({
    this.movieCategories = const [],
  });

  MoviesState copyWith({
    List<MovieCategory>? movieCategories,
  }) =>
      MoviesState(
        movieCategories: movieCategories ?? this.movieCategories,
      );
}

class MovieCategory {
  final String name;
  final String url;

  MovieCategory({
    required this.name,
    required this.url,
  });

  MovieCategory copyWith({
    String? name,
    String? url,
  }) =>
      MovieCategory(
        name: name ?? this.name,
        url: url ?? this.url,
      );
}
