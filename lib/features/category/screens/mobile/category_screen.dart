import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/shared/models/movie.dart';
import 'package:moviesplus/features/shared/models/movie_category.dart';
import 'package:moviesplus/features/shared/widgets/custom_appbar.dart';
import 'package:moviesplus/features/shared/widgets/movie_item.dart';
import 'package:moviesplus/features/shared/widgets/progress_indicator.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({
    super.key,
    required this.categoryKey,
  });

  @override
  CategoryScreenState createState() => CategoryScreenState();
  final String categoryKey;
}

class CategoryScreenState extends ConsumerState<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 0) <
          scrollController.position.maxScrollExtent) return;
      ref.read(moviesProvider.notifier).getMovies(widget.categoryKey);
    });
  }

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    MovieCategory? movieCategory =
        ref.watch(moviesProvider).movieCategories[widget.categoryKey];

    return Scaffold(
      appBar: CustomAppBar(
        title: movieCategory != null ? movieCategory.name(context) : 'Category',
      ),
      body: movieCategory == null
          ? const Text('Not found')
          : CustomScrollView(
              controller: scrollController,
              slivers: [
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
