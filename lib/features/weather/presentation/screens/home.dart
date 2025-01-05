import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_pod/features/weather/data/riverpod/fetch_weather_by_city.dart';

class DisplayWeatherCity extends StatelessWidget {
  const DisplayWeatherCity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        centerTitle: true,
      ),
      body: Center(child: Consumer(
        builder: (context, ref, child) {
          final weather = ref.watch(weatherProvider('London'));
          return weather.when(
            data: (data) => Text(
              data.city.name
            ),
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const CircularProgressIndicator(),
          );
        },
      )),
    );
  }
}
