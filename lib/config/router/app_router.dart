import 'package:go_router/go_router.dart';
import 'package:moviesplus/features/dashboard/screens/dashboard_screen.dart';
import 'package:moviesplus/features/movie/screens/movie_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const DashboardScreen();
      },
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
