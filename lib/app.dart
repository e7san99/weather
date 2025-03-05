import 'package:flutter/material.dart';
import 'package:weather/features/weather/presentation/screens/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),

      debugShowCheckedModeBanner: false,
      title: 'Weather',
      home: const HomeScreen(),
    );
  }
}
