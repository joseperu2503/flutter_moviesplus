import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/styles.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPaddingMobile,
          ),
          child: Text(
            'Cast and Crew',
            style: Styles.subtitle,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 60,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: horizontalPaddingMobile,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final Cast castPerson = cast[index];
              return CastItem(cast: castPerson);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 16,
              );
            },
            itemCount: cast.length,
          ),
        ),
      ],
    );
  }
}
