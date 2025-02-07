import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_pod/features/weather/data/riverpod/fetch_weather_by_city.dart';
import 'package:geolocator/geolocator.dart';

class DisplayWeatherCity extends StatefulWidget {
  const DisplayWeatherCity({super.key});

  @override
  State<DisplayWeatherCity> createState() => _DisplayWeatherCityState();
}

class _DisplayWeatherCityState extends State<DisplayWeatherCity> {
  final TextEditingController controller = TextEditingController();
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {

    

    void displayThirtyDayWeather(BuildContext context, String city) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Weather Forecast for $city'),
        ),
        body: Consumer(
          builder: (context, ref, child) {
            final thirtyDayWeather = ref.watch(thirtyDayWeatherProvider(city));
            return thirtyDayWeather.when(
              data: (data) {
                return ListView.builder(
                  itemCount: data.list.length,
                  itemBuilder: (context, index) {
                    double tempCelsius = data.list[index].main.temp - 273.15;
                     DateTime dateTime = DateTime.parse(data.list[index].dt_txt);
                      String formattedTime = DateFormat.jm().format(dateTime); // Formats time as 9:00 PM
                    return ListTile(
                      title: Text('${data.city.name} - Day ${index + 1}'),
                      subtitle: Text('${tempCelsius.toStringAsFixed(2)}°C'),
                      leading: Image.network('https://openweathermap.org/img/wn/${data.list[index].weather[0].icon}@2x.png'),
                      trailing: Text(formattedTime),
                    );
                  },
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
      );
    }),
  );
}
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: const Text('Weather'),
        centerTitle: true,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: controller,
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
                  onPressed: () {
                    ref.read(cityProvider.notifier).state = controller.text;
                  },
                  child: Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final city = ref.watch(cityProvider);
                    if (city.isEmpty && _currentPosition == null) {
                      return const Text('Please enter a city');
                    }

                    if (city.isEmpty) {
                      final weather = ref.watch(locationWeatherProvider(_currentPosition!));
                      return weather.when(
                        data: (data) {
                          double tempCelsius = data.list[0].main.temp - 273.15;
                          return Column(
                            children: [
                              Text('${data.city.name} ${tempCelsius.toStringAsFixed(2)}°C'),
                              Image.network('https://openweathermap.org/img/wn/${data.list[0].weather[0].icon}@2x.png'),
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
                    } else {
                      final weather = ref.watch(weatherProvider(city));
                      return weather.when(
                        data: (data) {
                          double tempCelsius = data.list[0].main.temp - 273.15;
                          return Column(
                            children: [
                              Text('${data.city.name} ${tempCelsius.toStringAsFixed(2)}°C'),
                              Image.network('https://openweathermap.org/img/wn/${data.list[0].weather[0].icon}@2x.png'),
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
                    }
                  },
                ),
                SizedBox(height: 20,),

                TextButton(
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.blue),
  ),
  onPressed: () {
    ref.read(cityProvider.notifier).state = controller.text;
    displayThirtyDayWeather(context, controller.text);
  },
  child: Text(
    'Search',
    style: TextStyle(
      color: Colors.white,
    ),
  ),
)
              ],
            ),
          );
        },
      ),
    );
  }
}