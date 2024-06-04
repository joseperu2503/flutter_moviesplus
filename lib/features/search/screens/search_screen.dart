import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/search/providers/search_provider.dart';
import 'package:moviesplus/features/search/widgets/search_input.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/models/movie_category.dart';
import 'package:moviesplus/features/shared/widgets/movie_item.dart';
import 'package:moviesplus/features/shared/widgets/progress_indicator.dart';
import 'package:moviesplus/generated/l10n.dart';

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
      if ((scrollController.position.pixels + 200) <
          scrollController.position.maxScrollExtent) return;
      ref.read(searchProvider.notifier).loadMoreMovies();
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
    if (ref.watch(moviesProvider).movieCategories.length > 1) {
      movieCategory = ref.watch(moviesProvider).movieCategories[1];
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
            toolbarHeight: 70,
            pinned: true,
            backgroundColor: AppColors.backgroundColor,
            flexibleSpace: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: SearchInput(
                        value: searchState.query,
                        onChanged: (value) {
                          ref.read(searchProvider.notifier).changeQuery(value);
                          if (value.isEmpty) {
                            scrollController.jumpTo(0);
                          }
                        },
                      ),
                    )
                  ],
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
                  left: 24,
                  top: 24,
                  bottom: 24,
                  right: 24,
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
                left: 24,
                right: 24,
              ),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.65,
                ),
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
                left: 24,
                right: 24,
              ),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.65,
                ),
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
                top: 10,
                bottom: 40,
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
