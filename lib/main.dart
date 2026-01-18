import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/splash_provider.dart';
import 'providers/task_provider.dart';
import 'data/models/task_model.dart';
import 'data/repositories/task_repository.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  final taskBox = await Hive.openBox<TaskModel>('tasks');


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(
          create: (_) => TaskProvider(TaskRepository(taskBox)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        initialRoute: AppRoutes.splash,
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(),
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorKey: navigatorKey,
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey =
GlobalKey<NavigatorState>();
