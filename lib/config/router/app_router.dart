import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/features/dashboard/screens/dashboard_screen.dart';
import 'package:moviesplus/features/movie/screens/movie_screen.dart';
import 'package:moviesplus/features/search/screens/search_screen.dart';
import 'package:moviesplus/features/shared/widgets/tabs.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state, navigationShell) {
        return Tabs(
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/movie/:movieId',
      builder: (context, state) {
        return MovieScreen(
          movieId: int.tryParse(state.pathParameters['movieId'] ?? '0') ?? 0,
        );
      },
    ),
  ],
);
