import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/dashboard/models/movies_response.dart';
import 'package:moviesplus/features/dashboard/providers/movies_provider.dart';
import 'package:moviesplus/features/search/widgets/search_input.dart';
import 'package:moviesplus/features/shared/widgets/movie_item.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MovieCategory movieCategory =
        ref.watch(moviesProvider).movieCategories[1];

    return Scaffold(
      body: CustomScrollView(
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
                child: const Row(
                  children: [
                    Expanded(
                      child: SearchInput(),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(
                left: 24,
                top: 24,
                bottom: 24,
                right: 24,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Recommendations',
                    style: TextStyle(
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
                final Movie movie = movieCategory.movies[index];

                return MovieItem(movie: movie);
              },
              itemCount: movieCategory.movies.length,
            ),
          )
        ],
      ),
    );
  }
}
