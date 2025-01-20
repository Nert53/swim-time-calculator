import 'package:code/constants.dart';
import 'package:code/view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'umimplavat.cz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: umimplavatMainColor, // color of umimplavat.cz
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 240, 240, 240),
      ),
      home: const HomeScreen(),
    );
  }
}
