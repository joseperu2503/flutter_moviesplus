import 'package:go_router/go_router.dart';
import 'package:moviesplus/features/auth/home/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
  ],
);
