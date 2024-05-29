import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/dashboard/models/movies_response.dart';
import 'package:moviesplus/features/shared/widgets/poster_image.dart';

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
      getMovies();
    });
    scrollController.addListener(() {
      getMovies();
    });
  }

  getMovies() async {
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
            horizontal: 16,
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
          height: 200,
          child: ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final Movie movie = widget.movies[index];
              return MovieItem(movie: movie);
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

class MovieItem extends StatelessWidget {
  const MovieItem({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GestureDetector(
          onTap: () {
            context.push('/movie/${movie.id}');
          },
          child: PosterImage(
            path: movie.posterPath,
          ),
        ),
      ),
    );
  }
}
