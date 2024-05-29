import 'package:flutter/material.dart';
import 'package:moviesplus/features/dashboard/models/movies_response.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/dashboard/services/movie_db_service.dart';
import 'package:moviesplus/features/dashboard/widgets/horizontal_list_movies.dart';

class TemporalHorizonalListMovies extends StatefulWidget {
  const TemporalHorizonalListMovies({
    super.key,
    required this.movieCategory,
  });

  final MovieCategory movieCategory;

  @override
  State<TemporalHorizonalListMovies> createState() =>
      _TemporalHorizonalListMoviesState();
}

class _TemporalHorizonalListMoviesState
    extends State<TemporalHorizonalListMovies> {
  List<Movie> movies = [];
  int page = 1;
  int totalPages = 1;
  bool loading = false;

  Future<void> getMovies() async {
    if (page > totalPages || loading) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final MoviesResponse response = await MovieDbService.getMovies(
        path: widget.movieCategory.url,
        page: widget.movieCategory.page,
        queryParameters: widget.movieCategory.queryParameters,
      );

      setState(() {
        movies = [...movies, ...response.results];
        page = page + 1;
        totalPages = response.totalPages;
      });
    } catch (e) {
      throw Exception(e);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HorizonalListMovies(
        label: widget.movieCategory.name, getMovies: getMovies, movies: movies);
  }
}
