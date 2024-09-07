import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/search/providers/search_provider.dart';
import 'package:moviesplus/features/search/widgets/search_input.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/models/movie_category.dart';
import 'package:moviesplus/features/shared/widgets/movie_item.dart';
import 'package:moviesplus/features/shared/widgets/progress_indicator.dart';
import 'package:moviesplus/generated/l10n.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 0) <
          scrollController.position.maxScrollExtent) return;
      ref.read(searchProvider.notifier).loadMoreMovies();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (ref.read(moviesProvider).movieCategories['popular'] == null) {
        await ref.read(moviesProvider.notifier).initDashboard();
        await ref.read(moviesProvider.notifier).getMovies('popular');
      }
    });
  }

  final scrollController = ScrollController();
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MovieCategory? movieCategory;
    if (ref.watch(moviesProvider).movieCategories['popular'] != null) {
      movieCategory = ref.watch(moviesProvider).movieCategories['popular'];
    }

    final searchState = ref.watch(searchProvider);

    final bool showResults =
        searchState.query.isNotEmpty && searchState.movies.isNotEmpty;
    final bool showRecommended =
        searchState.query.isEmpty && !searchState.loading;

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: kIsWeb ? 60 + 60 : 60,
            pinned: true,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor:
                  kIsWeb ? AppColors.backgroundColor : Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            flexibleSpace: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: AppColors.backgroundColor.withOpacity(0.5),
                  child: SafeArea(
                    child: Column(
                      children: [
                        if (kIsWeb)
                          Container(
                            height: 60,
                            padding: const EdgeInsets.only(
                              left: horizontalPaddingMobile,
                              right: horizontalPaddingMobile,
                            ),
                            child: Row(
                              children: [
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      context.go('/');
                                    },
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      height: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Container(
                          height: 60,
                          padding: const EdgeInsets.only(
                            left: horizontalPaddingMobile,
                            right: horizontalPaddingMobile,
                            bottom: 12,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SearchInput(
                                value: searchState.query,
                                onChanged: (value) {
                                  ref
                                      .read(searchProvider.notifier)
                                      .changeQuery(value);
                                  if (value.isEmpty) {
                                    scrollController.jumpTo(0);
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (searchState.loading && searchState.movies.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CustomProgressIndicator(),
              ),
            ),
          if (!searchState.loading)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(
                  left: horizontalPaddingMobile,
                  top: 24,
                  bottom: 24,
                  right: horizontalPaddingMobile,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showResults)
                      Text(
                        S.of(context).Results,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          height: 19.5 / 16,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                    if (showRecommended)
                      Text(
                        S.of(context).Recommended,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          height: 19.5 / 16,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          if (showRecommended && movieCategory != null)
            SliverPadding(
              padding: const EdgeInsets.only(
                left: horizontalPaddingMobile,
                right: horizontalPaddingMobile,
              ),
              sliver: SliverGrid.builder(
                gridDelegate:
                    movieSliverGridDelegate(MediaQuery.of(context).size.width),
                itemBuilder: (context, index) {
                  final Movie movie = movieCategory!.movies[index];

                  return MovieItem(movie: movie);
                },
                itemCount: movieCategory.movies.length,
              ),
            ),
          if (showResults)
            SliverPadding(
              padding: const EdgeInsets.only(
                left: horizontalPaddingMobile,
                right: horizontalPaddingMobile,
              ),
              sliver: SliverGrid.builder(
                gridDelegate:
                    movieSliverGridDelegate(MediaQuery.of(context).size.width),
                itemBuilder: (context, index) {
                  final Movie movie = searchState.movies[index];

                  return MovieItem(movie: movie);
                },
                itemCount: searchState.movies.length,
              ),
            ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(
                top: 24,
                bottom: 24,
              ),
              child: Center(
                child: searchState.loading && searchState.movies.isNotEmpty
                    ? const CustomProgressIndicator()
                    : null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
