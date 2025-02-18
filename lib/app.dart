import 'package:flutter/material.dart';
import 'package:weather_pod/features/weather/presentation/screens/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Pod',
      home: const HomeScreen(),
    );
  }
}
