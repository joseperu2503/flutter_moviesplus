import 'package:flutter/material.dart';
import 'package:moviesplus/features/movie/models/movie_credits.dart';
import 'package:moviesplus/features/movie/widgets/cast_item.dart';

class MovieCast extends StatelessWidget {
  const MovieCast({
    super.key,
    required this.cast,
  });

  final List<Cast> cast;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemBuilder: (context, index) {
        final Cast castPerson = cast[index];
        return CastItem(cast: castPerson);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 18,
        );
      },
      itemCount: cast.length,
    );
  }
}
