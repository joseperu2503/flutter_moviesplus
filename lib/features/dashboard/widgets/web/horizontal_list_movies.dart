import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/widgets/movie_item.dart';

class HorizontalListMoviesWeb extends ConsumerStatefulWidget {
  const HorizontalListMoviesWeb({
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

class HorizonalListMoviesState extends ConsumerState<HorizontalListMoviesWeb>
    with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();
  bool hover = false;
  @override
  void initState() {
    scrollController.addListener(() {
      loadMoreMovies();
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMoreMovies();
    });
    super.initState();
  }

  loadMoreMovies() async {
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

  toRight() {
    scrollController.animateTo(
      scrollController.position.pixels +
          MediaQuery.of(context).size.width -
          100,
      duration: const Duration(
        milliseconds: 250,
      ),
      curve: Curves.easeInOut,
    );
  }

  toLeft() {
    double scroll = scrollController.position.pixels -
        (MediaQuery.of(context).size.width - 100);
    if (scroll < 0) {
      scroll = 0;
    }
    scrollController.animateTo(
      scroll,
      duration: const Duration(
        milliseconds: 250,
      ),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: horizontalPaddingWeb,
            right: horizontalPaddingWeb - 16,
          ),
          child: Row(
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  height: 1,
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
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryBlueAccent,
                          height: 17.07 / 14,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        MouseRegion(
          onEnter: (event) {
            setState(() {
              hover = true;
            });
          },
          onExit: (event) {
            setState(() {
              hover = false;
            });
          },
          child: SizedBox(
            height: 200,
            child: Stack(
              children: [
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 42,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final Movie movie = widget.movies[index];

                      return MovieItem(
                        key: Key(movie.title),
                        movie: movie,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 16,
                      );
                    },
                    itemCount: widget.movies.length,
                  ),
                ),
                if (scrollController.hasClients &&
                    scrollController.position.pixels > 0)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: _DirectionButton(
                      hover: hover,
                      icon: 'assets/icons/arrow_back.svg',
                      onPress: () {
                        toLeft();
                      },
                    ),
                  ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: _DirectionButton(
                    hover: hover,
                    icon: 'assets/icons/arrow_next.svg',
                    onPress: () {
                      toRight();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DirectionButton extends StatelessWidget {
  const _DirectionButton({
    required this.hover,
    required this.onPress,
    required this.icon,
  });

  final bool hover;
  final void Function() onPress;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color:
            hover ? AppColors.primaryDark.withOpacity(0.5) : Colors.transparent,
      ),
      child: TextButton(
        onPressed: () {
          onPress();
        },
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Container(
          child: hover
              ? SvgPicture.asset(
                  icon,
                  width: 40,
                  height: 40,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
