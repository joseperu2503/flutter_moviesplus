import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/features/category/screens/web/category_screen.dart';
import 'package:moviesplus/features/dashboard/screens/web/dashboard_screen.dart';
import 'package:moviesplus/features/movie/widgets/movie_dialog.dart';
import 'package:moviesplus/features/search/screens/search_screen.dart';
import 'package:moviesplus/features/shared/layouts/layout_web.dart';
import 'package:moviesplus/features/shared/widgets/dialog_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> rootasdasNavigatorKey =
    GlobalKey<NavigatorState>();

final appRouterWeb = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return LayoutWeb(
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardScreen(),
          routes: [
            GoRoute(
              path: 'movie/:movieId',
              pageBuilder: (context, state) {
                return DialogPage(
                  key: PageStorageKey(state.uri),
                  builder: (context) {
                    return MovieDialog(
                      // key: PageStorageKey(state.uri),
                      movieId: state.pathParameters['movieId'] ?? '0',
                    );
                  },
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/genre/:genreId',
          builder: (context, state) {
            return CategoryScreenWeb(
              categoryKey: state.pathParameters['genreId'] ?? '0',
            );
          },
        ),
        GoRoute(
          path: '/movies/:categoryKey',
          builder: (context, state) {
            return CategoryScreenWeb(
              categoryKey: state.pathParameters['categoryKey'] ?? '0',
            );
          },
        ),
      ],
    ),
  ],
);
