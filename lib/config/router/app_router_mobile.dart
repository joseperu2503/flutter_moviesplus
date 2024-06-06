import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/features/category/screens/category_screen.dart';
import 'package:moviesplus/features/dashboard/screens/mobile/dashboard_screen.dart';
import 'package:moviesplus/features/movie/screens/movie_screen.dart';
import 'package:moviesplus/features/profile/screens/country_screen.dart';
import 'package:moviesplus/features/profile/screens/language_screen.dart';
import 'package:moviesplus/features/profile/screens/profile_screen.dart';
import 'package:moviesplus/features/search/screens/search_screen.dart';
import 'package:moviesplus/features/shared/widgets/tabs.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterMobile = GoRouter(
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
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/movie/:movieId',
      builder: (context, state) {
        return MovieScreen(
          movieId: state.pathParameters['movieId'] ?? '0',
        );
      },
    ),
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageScreen(),
      parentNavigatorKey: rootNavigatorKey,
    ),
    GoRoute(
      path: '/country',
      builder: (context, state) => const CountryScreen(),
      parentNavigatorKey: rootNavigatorKey,
    ),
    GoRoute(
      path: '/genre/:genreId',
      builder: (context, state) {
        return CategoryScreen(
          genreId: state.pathParameters['genreId'] ?? '0',
        );
      },
    ),
  ],
);
