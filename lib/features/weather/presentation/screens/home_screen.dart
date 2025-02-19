import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_pod/features/weather/data/riverpod/fetch_weather.dart';
import 'package:weather_pod/features/weather/presentation/widgets/appbar.dart';
import 'package:weather_pod/features/weather/presentation/widgets/cards/current_weather_card.dart';
import 'package:weather_pod/features/weather/presentation/widgets/cards/five_day_forecast.dart';
import 'package:weather_pod/features/weather/presentation/widgets/cards/next_hours_forecast.dart';
import 'package:weather_pod/features/weather/presentation/widgets/cards/title_cards.dart';
import 'package:weather_pod/features/weather/utils/constants/const.dart';
import 'package:weather_pod/features/weather/utils/extention.dart';
import 'package:weather_pod/features/weather/utils/shimmers/shimmering_weather_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  Position? _currentPosition;
  bool _isLocationDisable = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getCurrentLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLocationDisable = false;
      });
      return;
    }
    setState(() {
      _isLocationDisable = true;
    });

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
    return Scaffold(
      backgroundColor: Color(0xF5F5F5F5),
      appBar: AppbarHomePage(
          currentPosition: _currentPosition,
          searchController: _searchController),
      body: Consumer(
        builder: (context, ref, child) {
          final internetConnectionStatus =
              ref.watch(internetConnectionProvider);

          return internetConnectionStatus.when(
            data: (isConnected) {
              if (!isConnected) {
                return _noInternetConnection();
              }

              final useCurrentLocation = ref.watch(useCurrentLocationProvider);

              if (!_isLocationDisable) {
                return _locationServiceDisable();
              }

              final weather = useCurrentLocation
                  ? ref.watch(locationWeatherProvider(
                      _currentPosition ?? defaultPosition()))
                  : ref.watch(weatherProvider(ref.watch(cityProvider)));

              return weather.when(
                data: (data) {
                  final listElement = data.list[0];
                  DateTime dateTime = DateTime.parse(listElement.dt_txt);
                  String description = listElement.weather[0].description;
                  String capitalizedDescription =
                      description[0].toUpperCase() + description.substring(1);
                  double windSpeed = listElement.wind.speed;
                  String iconCode = listElement.weather[0].icon;
                  String imageUrl = getWeatherIcons(iconCode);
                  final nextHours = nextHoursfilteredList(data.list);
                  final fiveDayForecast = fiveDayForecastAt12PM(data.list);

                  return RefreshIndicator(
                    color: Colors.blue,
                    onRefresh: () async {
                      await Future.wait([_getCurrentLocation()]);
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CurrentWeatherCard(
                            tempCelsius: listElement.main.temp.toCelsius,
                            description: capitalizedDescription,
                            imageUrl: imageUrl,
                            formattedDate: formattedDate(dateTime),
                            tempMinCelsius: listElement.main.temp_min.toCelsius,
                            tempMaxCelsius: listElement.main.temp_max.toCelsius,
                            windSpeed: windSpeed,
                          ),
                          SizedBox(height: 10),
                          TitleCards(title: 'Next Hours'),
                          NextHoursForecast(nextHoursfilteredList: nextHours),
                          SizedBox(height: 10),
                          TitleCards(title: 'Five Day Forecast'),
                          FiveDayForecast(
                              fiveDayForecastAt12PM: fiveDayForecast),
                        ],
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) {
                  // Check if the error is a "city not found" error
                  if (error.toString().contains('City not found')) {
                    return _cityNotFound(error);
                  } else if (error.toString().contains(
                      'Failed to load data: The connection errored')) {
                    // Handle connection error (e.g., no internet)
                    return _noInternetConnection();
                  } else {
                    // Handle other errors
                    return Center(
                      child: Text(
                        'An error occurred: ${error.toString()}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                },
                loading: () {
                  return ShimmeringWeatherCards();
                },
              );
            },
            error: (error, stackTrace) {
              return Center(
                child: Text(
                  'An error occurred: ${error.toString()}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
            loading: () {
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }

  Center _noInternetConnection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
          ),
          Lottie.asset(
            'assets/json/no-internet.json', // Path to your JSON file
            width: 150, // Adjust width
            height: 150, // Adjust height
            fit: BoxFit.contain, // Adjust how the animation fits
            repeat: true, // Set to true if you want the animation to loop
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            'No Internet Connection',
            style: GoogleFonts.amaranth(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // You can add logic to retry checking the internet connection
              _getCurrentLocation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: Text(
              'Retry',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Center _cityNotFound(Object error) {
    return Center(
      child: Column(
        children: [
          Lottie.asset(
            'assets/json/city.json', // Path to your JSON file
            width: 300, // Adjust width
            height: 300, // Adjust height
            fit: BoxFit.contain, // Adjust how the animation fits
            repeat: true, // Set to true if you want the animation to loop
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${_searchController.text} ', // City name
                  style: GoogleFonts.amaranth(
                    textStyle: TextStyle(
                      color: Colors.blue, // Blue for city name
                      fontSize: 18,
                    ),
                  ),
                ),
                TextSpan(
                  text: 'not found.', // Error message
                  style: GoogleFonts.amaranth(
                    textStyle: TextStyle(
                      color: Colors.black, // Red for "not found."
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            error.toString().contains('City not found')
                ? ' Check the name and try again!'
                : 'An error occurred. Please try again.',
            style: GoogleFonts.amaranth(
              textStyle: TextStyle(
                color: Colors.black, // Black color for the rest of the text
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center _locationServiceDisable() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 50),
          Lottie.asset(
            'assets/json/location.json', // Path to your JSON file
            width: 330, // Adjust width
            // height: 330, // Adjust height
            fit: BoxFit.contain, // Adjust how the animation fits
            repeat: true, // Set to true if you want the animation to loop
          ),
          Text(
            'Location services are disabled.',
            style: GoogleFonts.amaranth(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 80),
          ElevatedButton(
            onPressed: () async {
              bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
              if (!serviceEnabled) {
                Geolocator.openLocationSettings();
              }
              await _getCurrentLocation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: Text(
              'Enable Location Services',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
