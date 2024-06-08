import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/models/movie_category.dart';
import 'package:moviesplus/features/shared/widgets/custom_sliver_builder.dart';
import 'package:moviesplus/features/shared/widgets/movie_item.dart';
import 'package:moviesplus/features/shared/widgets/progress_indicator.dart';

class CategoryScreenWeb extends ConsumerStatefulWidget {
  const CategoryScreenWeb({
    super.key,
    required this.categoryKey,
  });

  @override
  CategoryScreenState createState() => CategoryScreenState();
  final String categoryKey;
}

class CategoryScreenState extends ConsumerState<CategoryScreenWeb> {
  @override
  void initState() {
    super.initState();
    scrollController.addListener(getMovies);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (ref.read(moviesProvider).movieCategories.isEmpty) {
        await ref.read(moviesProvider.notifier).initDashboard();
      }
      await getMovies();
    });
  }

  final scrollController = ScrollController();
  getMovies() async {
    if (scrollController.hasClients &&
        (scrollController.position.pixels + 400) <
            scrollController.position.maxScrollExtent) return;
    await ref.read(moviesProvider.notifier).getMovies(widget.categoryKey);
    await Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        await getMovies();
      },
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(getMovies);
    super.dispose();
  }

  bool counter = false;

  @override
  Widget build(BuildContext context) {
    MovieCategory? movieCategory =
        ref.watch(moviesProvider).movieCategories[widget.categoryKey];
    final screen = MediaQuery.of(context);
    final double maxWidth = screen.size.height * 1.1;

    return Scaffold(
      body: movieCategory == null
          ? const Text('Not found')
          : CustomScrollView(
              controller: scrollController,
              slivers: [
                CustomSliverBuilder(
                  maxWidth: maxWidth,
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPaddingWeb,
                  ),
                  builder: (context, constraints) => SliverAppBar(
                    backgroundColor: AppColors.headerWeb,
                    toolbarHeight: 150,
                    pinned: true,
                    automaticallyImplyLeading: false,
                    scrolledUnderElevation: 0,
                    flexibleSpace: Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(
                        top: heightAppbar + 10,
                        bottom: 20,
                      ),
                      child: Text(
                        movieCategory.name(context),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          height: 19.5 / 16,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                    ),
                  ),
                ),
                CustomSliverBuilder(
                  maxWidth: maxWidth,
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPaddingWeb,
                  ),
                  builder: (context, constraints) => SliverGrid.builder(
                    gridDelegate: movieSliverGridDelegate(
                      constraints.crossAxisExtent,
                    ),
                    itemBuilder: (context, index) {
                      final Movie movie = movieCategory.movies[index];

                      return MovieItem(movie: movie);
                    },
                    itemCount: movieCategory.movies.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 24,
                      bottom: 24,
                    ),
                    child: Center(
                      child: movieCategory.loading &&
                              movieCategory.movies.isNotEmpty
                          ? const CustomProgressIndicator()
                          : null,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
