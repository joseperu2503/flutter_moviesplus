import 'package:go_router/go_router.dart';
import 'package:moviesplus/features/dashboard/screens/dashboard_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const DashboardScreen();
      },
    ),
  ],
);
