import 'package:flutter/material.dart';
import '../data/models/task_model.dart';
import '../ui/screens/add_edit_task/add_edit_task_screen.dart';
import '../ui/screens/splash/splash_screen.dart';
import '../ui/screens/task_list/task_list_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case AppRoutes.splash:
        return _pageRoute(const SplashScreen());

      case AppRoutes.tasks:
        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, _, _) => const TaskListScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case AppRoutes.addEditTask:
        final args = settings.arguments;

        return _pageRoute(
          AddEditTaskScreen(
            task: args is TaskModel ? args : null,
          ),
        );

      default:
        return _errorRoute();
    }
  }

  static PageRoute _pageRoute(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Route not found'),
        ),
      ),
    );
  }
}

