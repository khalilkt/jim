import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jim/constants.dart';
import 'package:jim/ss.dart';

import 'BloC/workout_cubit.dart';
import 'Models/workout_model.dart';
import 'Pages/create__ww_page.dart';
import 'Pages/home_page.dart';
import 'Pages/live_workout_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Router router = Router();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jim',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Inter',
          backgroundColor: backColor,
          textTheme:
              const TextTheme(bodyText2: TextStyle(color: Colors.white))),
      onGenerateRoute: router.onGenerateRoute,
    );
  }
}

class Router {
  WorkoutCubit workoutCubit = WorkoutCubit();
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Pages.home:
        return MaterialPageRoute(builder: (_) {
          return Builder(builder: (context) {
            if (!SS.inited) {
              SS.init(MediaQuery.of(context).size);
            }
            return BlocProvider.value(
                value: workoutCubit, child: const HomePage());
          });
        });
      case Pages.createWorkout:
        return MaterialPageRoute(builder: (_) {
          return BlocProvider.value(
              value: workoutCubit, child: const CreateEditWorkoutPage());
        });
      case Pages.liveWorkout:
        return MaterialPageRoute(builder: (_) {
          return LiveWorkoutPage(settings.arguments as Workout);
        });

      default:
        throw Exception('route name is ${settings.name} WTF');
    }
  }
}

abstract class Pages {
  static const String home = '/';
  static const String createWorkout = '/create_ww';
  static const String liveWorkout = '/live_ww';
}
