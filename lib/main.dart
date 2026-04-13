import 'package:code/constants.dart';
import 'package:code/data/database_drift.dart';
import 'package:code/view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

late AppDatabase database;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft
  ]);
  database = AppDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swim Time Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: umimplavatMainColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 240, 240, 240),
      ),
      home: HomeScreen(),
    );
  }
}
