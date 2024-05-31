import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/features/dashboard/models/movies_response.dart';
import 'package:moviesplus/features/dashboard/services/movie_db_service.dart';
import 'package:moviesplus/features/shared/models/movie.dart';

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier(this.ref) : super(SearchState());
  final StateNotifierProviderRef ref;

  getMovies() async {
    state = state.copyWith(
      loading: true,
    );
    final query = state.query;

    try {
      final MoviesResponse response = await MovieDbService.getMovies(
        path: '/search/movie',
        page: state.page,
        queryParameters: {
          "query": state.query,
        },
      );

      if (query == state.query) {
        state = state.copyWith(
          movies: [...state.movies, ...response.results],
          page: state.page + 1,
          totalPages: response.totalPages,
        );
      }
    } catch (e) {
      throw Exception(e);
    }

    if (query == state.query) {
      state = state.copyWith(
        loading: false,
      );
    }
  }

  loadMoreMovies() {
    if (state.page > state.totalPages || state.loading || state.query.isEmpty) {
      return;
    }
    getMovies();
  }

  Timer? _debounceTimer;

  changeQuery(String query) {
    state = state.copyWith(
      movies: [],
      page: 1,
      totalPages: 1,
      loading: false,
      query: query,
    );

    if (query.isNotEmpty) {
      state = state.copyWith(
        loading: true,
      );

      if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
      _debounceTimer = Timer(
        const Duration(milliseconds: 1000),
        () {
          if (query != state.query) return;
          getMovies();
        },
      );
    }
  }
}

class SearchState {
  final List<Movie> movies;
  final int page;
  final int totalPages;
  final bool loading;
  final String query;

  SearchState({
    this.movies = const [],
    this.page = 1,
    this.totalPages = 1,
    this.loading = false,
    this.query = '',
  });

  SearchState copyWith({
    List<Movie>? movies,
    int? page,
    int? totalPages,
    bool? loading,
    String? query,
  }) =>
      SearchState(
        movies: movies ?? this.movies,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        loading: loading ?? this.loading,
        query: query ?? this.query,
      );
}
