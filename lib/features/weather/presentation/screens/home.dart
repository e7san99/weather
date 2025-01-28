import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_pod/features/weather/data/riverpod/fetch_weather_by_city.dart';

class DisplayWeatherCity extends StatefulWidget {
  const DisplayWeatherCity({super.key});

  @override
  State<DisplayWeatherCity> createState() => _DisplayWeatherCityState();
}

class _DisplayWeatherCityState extends State<DisplayWeatherCity> {
  String city = 'London';

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
                onChanged: (value) => setState(() => city = value),
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
                    weatherProvider(city)); // Update with fetched location
                return weather.when(
                  data: (data) {
                    double tempCelsius = data.list[0].main.temp - 273.15;
                    return Column(
                      children: [
                        Text(
                            '${data.city.name} ${tempCelsius.toStringAsFixed(2)}°C'),
                        // Text( "${(myState.weatherModel!.mainObjectModel.temp).toStringAsFixed(2)} C°",),
                      ],
                    );
                  },
                  error: (error, stackTrace) => Text(
                    error.toString().contains('City not found')
                        ? 'City not found. Please try again.'
                        : 'An error occurred. Please try again.',
                    style: TextStyle(color: Colors.purple),
                  ),
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
