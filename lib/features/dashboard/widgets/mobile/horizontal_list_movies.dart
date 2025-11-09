import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/widgets/movie_item.dart';
import 'package:moviesplus/generated/l10n.dart';

class HorizonalListMovies extends ConsumerStatefulWidget {
  const HorizonalListMovies({
    super.key,
    required this.label,
    required this.getMovies,
    required this.movies,
    this.seeMoreUrl,
  });

  final String label;
  final Future<void> Function() getMovies;
  final List<Movie> movies;
  final String? seeMoreUrl;

  @override
  HorizonalListMoviesState createState() => HorizonalListMoviesState();
}

class HorizonalListMoviesState extends ConsumerState<HorizonalListMovies>
    with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.getMovies();
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
        Padding(
          padding: const EdgeInsets.only(
            left: horizontalPaddingMobile,
            right: horizontalPaddingMobile - 16,
          ),
          child: Row(
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                  height: 1.2,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
              const Spacer(),
              if (widget.seeMoreUrl != null)
                TextButton(
                  onPressed: () {
                    context.push(widget.seeMoreUrl!);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        S.of(context).seeAll,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryBlueAccent,
                          height: 17.07 / 14,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      SvgPicture.asset(
                        'assets/icons/arrow_forward.svg',
                        width: 10,
                        height: 10,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primaryBlueAccent,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          height: _listViewHeight,
          child: ListView.separated(
            controller: scrollController,
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
