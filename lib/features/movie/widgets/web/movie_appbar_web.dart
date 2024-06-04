import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/movie/models/movie_detail.dart';
import 'package:moviesplus/features/shared/widgets/backdrop_image.dart';
import 'package:moviesplus/features/shared/widgets/close_button.dart';

class MovieAppbarWeb extends StatefulWidget {
  const MovieAppbarWeb({
    super.key,
    required this.movieDetail,
    required this.heroTag,
  });

  final MovieDetail movieDetail;
  final String heroTag;

  @override
  State<MovieAppbarWeb> createState() => _MovieAppbarWebState();
}

class _MovieAppbarWebState extends State<MovieAppbarWeb> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      titleSpacing: 0,
      toolbarHeight: 90,
      title: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 24,
        ),
        child: const Row(
          children: [
            Spacer(),
            CustomCloseButton(),
          ],
        ),
      ),
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      pinned: true,
      backgroundColor: AppColors.backgroundColor,
      expandedHeight: 450,
      collapsedHeight: 200,
      flexibleSpace: Stack(
        children: [
          BackdropImage(
            path: widget.movieDetail.backdropPath,
            height: 550,
            width: double.infinity,
          ),
          //
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 80,
              width: double.infinity,
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      widget.movieDetail.title ?? '',
                      style: const TextStyle(
                        fontSize: 32,
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
        ],
      ),
    );
  }
}
