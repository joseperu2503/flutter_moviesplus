import 'package:flutter/material.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/widgets/movie_item.dart';

class SliverInfinityScroll extends StatefulWidget {
  const SliverInfinityScroll({
    super.key,
    required this.movies,
    required this.getMovies,
    required this.scrollController,
  });

  final List<Movie> movies;
  final ScrollController scrollController;
  final Future<void> Function() getMovies;

  @override
  State<SliverInfinityScroll> createState() => _SliverInfinityScrollState();
}

class _SliverInfinityScrollState extends State<SliverInfinityScroll> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      widget.getMovies();
    });
    widget.scrollController.addListener(loadMoreMovies);
  }

  loadMoreMovies() async {
    if ((widget.scrollController.position.pixels + 200) <
        widget.scrollController.position.maxScrollExtent) return;

    await Future.delayed(const Duration(milliseconds: 300));

    if ((widget.scrollController.position.pixels + 200) <
        widget.scrollController.position.maxScrollExtent) return;

    await widget.getMovies();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(loadMoreMovies);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid.builder(
        itemBuilder: (context, index) {
          final movie = widget.movies[index];
          return MovieItem(movie: movie);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 20,
          mainAxisExtent: 210,
        ),
        itemCount: widget.movies.length,
      ),
    );
  }
}
