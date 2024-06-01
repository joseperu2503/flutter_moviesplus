import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/widgets/poster_image.dart';

class MovieItem extends ConsumerWidget {
  const MovieItem({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 150,
      height: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GestureDetector(
          onTap: () {
            ref.read(moviesProvider.notifier).setTemporalMovie(movie);
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
