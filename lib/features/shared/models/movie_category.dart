import 'package:flutter/material.dart';
import 'package:moviesplus/features/shared/models/movie.dart';

class MovieCategory {
  final String Function(BuildContext context) name;
  final String url;
  final Map<String, dynamic> queryParameters;
  final List<Movie> movies;
  final int page;
  final int totalPages;
  final bool loading;
  final String? seeMoreUrl;

  MovieCategory({
    required this.name,
    required this.url,
    this.queryParameters = const {},
    this.movies = const [],
    this.page = 1,
    this.totalPages = 1,
    this.loading = false,
    this.seeMoreUrl,
  });

  MovieCategory copyWith({
    List<Movie>? movies,
    int? page,
    int? totalPages,
    bool? loading,
  }) =>
      MovieCategory(
        name: name,
        url: url,
        queryParameters: queryParameters,
        movies: movies ?? this.movies,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        loading: loading ?? this.loading,
        seeMoreUrl: seeMoreUrl,
      );
}
