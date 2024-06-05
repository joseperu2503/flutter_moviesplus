import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/dashboard/widgets/web/appbar.dart';
import 'package:moviesplus/features/dashboard/widgets/web/horizontal_list_movies.dart';
import 'package:moviesplus/features/dashboard/widgets/web/poster.dart';
import 'package:moviesplus/features/shared/models/movie_category.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(moviesProvider.notifier).initDashboard();
    });
    super.initState();
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
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              const PosterDashboard(),
              SliverList.separated(
                itemBuilder: (context, index) {
                  final MovieCategory movieCategory = movieCategories[index];
                  return HorizontalListMoviesWeb(
                    key: Key(movieCategory.name(context)),
                    label: movieCategory.name(context),
                    getMovies: () async {
                      await ref.read(moviesProvider.notifier).getMovies(index);
                    },
                    movies: movieCategory.movies,
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
          AppbarWeb(scrollController: _scrollController),
        ],
      ),
    );
  }
}
