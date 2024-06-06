import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/widgets/movie_item.dart';

class HorizonalListMovies extends ConsumerStatefulWidget {
  const HorizonalListMovies({
    super.key,
    required this.label,
    required this.getMovies,
    required this.movies,
  });

  final String label;
  final Future<void> Function() getMovies;
  final List<Movie> movies;

  @override
  HorizonalListMoviesState createState() => HorizonalListMoviesState();
}

class HorizonalListMoviesState extends ConsumerState<HorizonalListMovies>
    with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadMoreMovies();
    });
    scrollController.addListener(() {
      loadMoreMovies();
    });
  }

  loadMoreMovies() async {
    if ((scrollController.position.pixels + 600) <
        scrollController.position.maxScrollExtent) return;

    await Future.delayed(const Duration(milliseconds: 300));

    if ((scrollController.position.pixels + 600) <
        scrollController.position.maxScrollExtent) return;

    await widget.getMovies();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Row(
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  height: 19.5 / 16,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          height: 240,
          child: ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final Movie movie = widget.movies[index];
              return MovieItem(
                movie: movie,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 10,
              );
            },
            itemCount: widget.movies.length,
          ),
        ),
      ],
    );
  }
}
