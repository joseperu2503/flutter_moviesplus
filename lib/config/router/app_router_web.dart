import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/features/dashboard/screens/web/dashboard_screen.dart';
import 'package:moviesplus/features/movie/screens/movie_screen.dart';
import 'package:moviesplus/features/profile/screens/country_screen.dart';
import 'package:moviesplus/features/profile/screens/language_screen.dart';
import 'package:moviesplus/features/profile/screens/profile_screen.dart';
import 'package:moviesplus/features/search/screens/search_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterWeb = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/movie/:movieId',
      builder: (context, state) {
        return MovieScreen(
          movieId: int.tryParse(state.pathParameters['movieId'] ?? '0') ?? 0,
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
  ],
);
