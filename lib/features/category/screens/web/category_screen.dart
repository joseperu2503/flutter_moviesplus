import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/models/movie_category.dart';
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
        (scrollController.position.pixels + 200) <
            scrollController.position.maxScrollExtent) return;
    await ref.read(moviesProvider.notifier).getMovies(widget.categoryKey);
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

    return Scaffold(
      body: movieCategory == null
          ? const Text('Not found')
          : CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: heightAppbar + 10,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                  ),
                  sliver: SliverGrid.builder(
                    gridDelegate: movieSliverGridDelegate(context),
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
                )
              ],
            ),
    );
  }
}
