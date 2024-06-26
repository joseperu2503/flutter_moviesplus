import 'package:flutter/material.dart';
import 'package:moviesplus/features/movie/screens/movie_screen.dart';

class MovieDialog extends StatelessWidget {
  const MovieDialog({
    super.key,
    required this.movieId,
  });
  final String movieId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: MovieScreen(
            movieId: movieId,
          ),
        ),
      ),
    );
  }
}
