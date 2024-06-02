import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/widgets/poster_image.dart';
import 'package:uuid/uuid.dart';

class MovieItem extends ConsumerStatefulWidget {
  const MovieItem({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  MovieItemState createState() => MovieItemState();
}

class MovieItemState extends ConsumerState<MovieItem> {
  String tag = const Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '${widget.movie.id}$tag',
      child: SizedBox(
        width: 150,
        height: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GestureDetector(
            onTap: () {
              ref
                  .read(moviesProvider.notifier)
                  .setHeroTag('${widget.movie.id}$tag');
              ref.read(moviesProvider.notifier).setTemporalMovie(widget.movie);
              context.push('/movie/${widget.movie.id}');
            },
            child: PosterImage(
              path: widget.movie.posterPath,
            ),
          ),
        ),
      ),
    );
  }
}
