import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const FindThatSongApp());
}

class FindThatSongApp extends StatelessWidget {
  const FindThatSongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find That Song',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
