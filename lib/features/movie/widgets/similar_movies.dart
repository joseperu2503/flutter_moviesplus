import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/widgets/movie_item.dart';

class SimilarMovies extends ConsumerStatefulWidget {
  const SimilarMovies({
    super.key,
    required this.movies,
  });

  final List<Movie> movies;

  @override
  HorizonalListMoviesState createState() => HorizonalListMoviesState();
}

class HorizonalListMoviesState extends ConsumerState<SimilarMovies>
    with AutomaticKeepAliveClientMixin {
  final double _widthSeparator = 10;
  MediaQueryData get _screen => MediaQuery.of(context);
  int get _numMovies => numMovieColumns(_screen.size.width);

  //calculo para que se vea la cantidad de peliculas establecidas por numMovieColumns
  //mas una parte de la siguiente pelicula
  double get _listViewHeight =>
      (_screen.size.width -
          horizontalPaddingMobile -
          (_numMovies) * _widthSeparator) /
      ((_numMovies + 0.3) * posterAspectRatio);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: horizontalPaddingMobile,
            right: horizontalPaddingMobile - 16,
          ),
          child: Text(
            'Similar Movies',
            style: Styles.subtitle,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          height: _listViewHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: horizontalPaddingMobile,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final Movie movie = widget.movies[index];
              return MovieItem(
                movie: movie,
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: _widthSeparator,
              );
            },
            itemCount: widget.movies.length,
          ),
        ),
      ],
    );
  }
}
