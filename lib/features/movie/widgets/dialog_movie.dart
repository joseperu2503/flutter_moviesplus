import 'package:flutter/material.dart';
import 'package:moviesplus/features/movie/screens/movie_screen.dart';

class DialogMovie extends StatelessWidget {
  const DialogMovie({
    super.key,
    required this.movieId,
  });
  final int movieId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 800,
        ),
        child: MovieScreen(
          movieId: movieId,
        ),
      ),
    );
  }
}
