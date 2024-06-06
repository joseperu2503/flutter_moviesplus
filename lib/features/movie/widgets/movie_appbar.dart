import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/breakpoints.dart';
import 'package:moviesplus/features/movie/models/movie_detail.dart';
import 'package:moviesplus/features/shared/widgets/back_button.dart';
import 'package:moviesplus/features/shared/widgets/backdrop_image.dart';
import 'package:moviesplus/features/shared/widgets/close_button.dart';
import 'package:moviesplus/features/shared/widgets/poster_image.dart';

class MovieAppbar extends StatefulWidget {
  const MovieAppbar({
    super.key,
    required this.movieDetail,
    required this.scrollController,
    required this.heroTag,
  });

  final MovieDetail movieDetail;
  final ScrollController scrollController;
  final String heroTag;

  @override
  State<MovieAppbar> createState() => _MovieAppbarState();
}

class _MovieAppbarState extends State<MovieAppbar> {
  double top = 0;
  double width = 205;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListenerPoster);
  }

  _scrollListenerPoster() {
    final screen = MediaQuery.of(context);
    setState(() {
      if (widget.scrollController.offset < 0) {
        top = screen.padding.top + 60;
        width = 205;
      } else if (widget.scrollController.offset < screen.padding.top + 60) {
        top = screen.padding.top + 60 - widget.scrollController.offset;
        width = 205 +
            (screen.size.width - 205) *
                (widget.scrollController.offset) /
                (screen.padding.top + 60);
      } else {
        top = 0;
        width = screen.size.width;
      }
    });
  }

  bool get showTitle {
    if (isPhone) {
      return true;
    }
    return (widget.scrollController.offset > 160);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListenerPoster);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screen = MediaQuery.of(context);
    top = screen.padding.top + 60;
  }

  bool get isPhone => MediaQuery.of(context).size.width < Breakpoints.mobile;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    return SliverAppBar(
      titleSpacing: 0,
      toolbarHeight: 60,
      title: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          children: const [
            if (!kIsWeb) CustomBackButton(),
            Spacer(),
            if (kIsWeb) CustomCloseButton(),
          ],
        ),
      ),
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      pinned: true,
      backgroundColor: AppColors.backgroundColor,
      expandedHeight: !isPhone ? 300 : 450,
      collapsedHeight: 200,
      flexibleSpace: Stack(
        children: [
          if (isPhone)
            //** Poster Phone */
            PosterImage(
              path: widget.movieDetail.posterPath,
              height: 550,
              width: double.infinity,
              opacity: const AlwaysStoppedAnimation(0.4),
            ),

          if (isPhone)
            //** Filter Tablet */
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 1],
                  colors: [
                    AppColors.backgroundColor.withOpacity(0.2),
                    AppColors.backgroundColor,
                  ],
                ),
              ),
            ),
          if (isPhone)
            //** Poster Phone */
            Positioned(
              top: top,
              child: Hero(
                tag: widget.heroTag,
                child: Container(
                  width: screen.size.width,
                  alignment: Alignment.topCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PosterImage(
                      path: widget.movieDetail.posterPath,
                      width: width,
                    ),
                  ),
                ),
              ),
            ),
          if (!isPhone)
            //** Backdrop Tablet */
            BackdropImage(
              path: widget.movieDetail.backdropPath,
              height: 550,
              width: double.infinity,
            ),
          //** Movie Title */
          Positioned(
            bottom: -5,
            right: 0,
            left: 0,
            child: Container(
              height: 80,
              width: screen.size.width,
              padding: const EdgeInsets.only(
                left: 24,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 1],
                  colors: [
                    AppColors.backgroundColor.withOpacity(0),
                    AppColors.backgroundColor,
                  ],
                ),
              ),
              child: Offstage(
                offstage: !showTitle,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        widget.movieDetail.title ?? '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
