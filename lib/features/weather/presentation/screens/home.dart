import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_pod/features/weather/data/riverpod/fetch_weather.dart';

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
                final thirtyDayWeather =
                    ref.watch(nextDaysWeatherProvider(city));
                return thirtyDayWeather.when(
                  data: (data) {
                    return ListView.builder(
                      itemCount: data.list.length,
                      itemBuilder: (context, index) {
                        String iconCode = data.list[index].weather[0].icon;
                        String imageUrl;

                        switch (iconCode) {
                          //days
                          case '01d':
                            imageUrl = 'assets/icons/01d.png';
                            break;
                          case '02d':
                            imageUrl = 'assets/icons/02d.png';
                            break;
                          case '03d':
                            imageUrl = 'assets/icons/03d.png';
                            break;
                          case '04d':
                            imageUrl = 'assets/icons/04d.png';
                            break;
                          case '09d':
                            imageUrl = 'assets/icons/09d.png';
                            break;
                          case '10d':
                            imageUrl = 'assets/icons/10d.png';
                            break;
                          case '11d':
                            imageUrl = 'assets/icons/11d.png';
                            break;
                          case '13d':
                            imageUrl = 'assets/icons/13d.png';
                            break;
                          case '50d':
                            imageUrl = 'assets/icons/50d.png';
                            break;
                          //nights
                          case '01n':
                            imageUrl = 'assets/icons/01n.png';
                            break;
                          case '02n':
                            imageUrl = 'assets/icons/02n.png';
                            break;
                          case '03n':
                            imageUrl = 'assets/icons/03n.png';
                            break;
                          case '04n':
                            imageUrl = 'assets/icons/04n.png';
                            break;
                          case '09n':
                            imageUrl = 'assets/icons/09n.png';
                            break;
                          case '10n':
                            imageUrl = 'assets/icons/10n.png';
                            break;
                          case '11n':
                            imageUrl = 'assets/icons/11n.png';
                            break;
                          case '13n':
                            imageUrl = 'assets/icons/13n.png';
                            break;
                          case '50n':
                            imageUrl = 'assets/icons/50n.png';
                            break;
                          default:
                            imageUrl = 'assets/icons/moon.png';
                            break;
                        }

                        double tempCelsius =
                            data.list[index].main.temp - 273.15;
                        DateTime dateTime =
                            DateTime.parse(data.list[index].dt_txt);
                        String formattedTime =
                            DateFormat.yMd().add_jm().format(dateTime);

                        return ListTile(
                          // title: Text('${data.city.name} - Day ${index + 1}'),
                          title: Text('${tempCelsius.toStringAsFixed(2)}°C'),
                          leading: Image.asset(
                            imageUrl,
                            height: 35,
                            fit: BoxFit.fill,
                            // color: whiteColor,
                          ),
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
                      final weather =
                          ref.watch(locationWeatherProvider(_currentPosition!));
                      return weather.when(
                        data: (data) {
                          double tempCelsius = data.list[0].main.temp - 273.15;
                          return Column(
                            children: [
                              Text(
                                  '${data.city.name} ${tempCelsius.toStringAsFixed(2)}°C'),
                              Image.network(
                                  'https://openweathermap.org/img/wn/${data.list[0].weather[0].icon}@2x.png'),
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
                              Text(
                                  '${data.city.name} ${tempCelsius.toStringAsFixed(2)}°C'),
                              Image.network(
                                  'https://openweathermap.org/img/wn/${data.list[0].weather[0].icon}@2x.png'),
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
                SizedBox(
                  height: 20,
                ),
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

/*
texfield
TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  // fillColor: Colors.blue,
                  // filled: true,
                  hintText: 'Search...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.blue),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _toggleSearch();
                    },
                    icon: Icon(Icons.close, color: Colors.blue),
                  )),
              style: TextStyle(color: Colors.blue),
              onSubmitted: (value) {
                // Handle the search query here
                print('Search query: $value');
                _toggleSearch(); // Optionally close the search bar after submission
              },
            )
*/