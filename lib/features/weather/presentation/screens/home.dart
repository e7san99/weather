import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_pod/features/weather/data/riverpod/fetch_weather_by_city.dart';

class DisplayWeatherCity extends StatefulWidget {
  const DisplayWeatherCity({super.key});

  @override
  State<DisplayWeatherCity> createState() => _DisplayWeatherCityState();
}

class _DisplayWeatherCityState extends State<DisplayWeatherCity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: const Text('Weather'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                decoration: const InputDecoration(
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.blue,
                  )),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.blue,
                  )),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  labelText: 'City',
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
              ),
              onPressed: () {},
              child: Text(
                'Search',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                final weather = ref.watch(
                    weatherProvider('London')); // Update with fetched location
                return weather.when(
                  data: (data) => Text(data.city.name),
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
