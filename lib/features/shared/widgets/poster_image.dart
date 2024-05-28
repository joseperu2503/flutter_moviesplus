import 'package:flutter/material.dart';

class PosterImage extends StatelessWidget {
  const PosterImage({
    super.key,
    required this.path,
  });

  final String? path;

  @override
  Widget build(BuildContext context) {
    if (path != null) {
      return FadeInImage(
        fit: BoxFit.cover,
        placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
        image: NetworkImage('https://image.tmdb.org/t/p/w500$path'),
      );
    }

    return const FadeInImage(
      fit: BoxFit.cover,
      placeholder: AssetImage('assets/loaders/bottle-loader.gif'),
      image: AssetImage('assets/images/no-image-found.png'),
    );
  }
}
