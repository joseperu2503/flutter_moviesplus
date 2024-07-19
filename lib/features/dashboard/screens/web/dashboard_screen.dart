import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/dashboard/widgets/web/appbar.dart';
import 'package:moviesplus/features/dashboard/widgets/web/horizontal_list_movies.dart';
import 'package:moviesplus/features/dashboard/widgets/web/poster.dart';
import 'package:moviesplus/features/shared/models/movie_category.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(moviesProvider.notifier).initDashboard();
    });
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieCategories = ref.watch(moviesProvider).movieCategories;
    final List<MapEntry<String, MovieCategory>> categoryList =
        movieCategories.entries.toList();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppbarWeb(scrollController: _scrollController),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const PosterDashboard(),
          SliverList.separated(
            itemBuilder: (context, index) {
              final MovieCategory movieCategory = categoryList[index].value;
              final String key = categoryList[index].key;

              return HorizontalListMoviesWeb(
                key: PageStorageKey(
                  '${movieCategory.name(context)}${Localizations.localeOf(context)}',
                ),
                label: movieCategory.name(context),
                getMovies: () async {
                  await ref.read(moviesProvider.notifier).getMovies(key);
                },
                movies: movieCategory.movies,
                seeMoreUrl: movieCategory.seeMoreUrl,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 32,
              );
            },
            itemCount: movieCategories.length,
          )
        ],
      ),
    );
  }
}
