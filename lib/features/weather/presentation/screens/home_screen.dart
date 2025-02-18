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
                      FiveDayForecast(fiveDayForecastAt12PM: fiveDayForecast),
                    ],
                  ),
                ),
              );
            },
            error: (error, stackTrace) {
              return Center(
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/json/city.json', // Path to your JSON file
                      width: 300, // Adjust width
                      height: 300, // Adjust height
                      fit: BoxFit.contain, // Adjust how the animation fits
                      repeat:
                          true, // Set to true if you want the animation to loop
                    ),
                    Text(
                      error.toString().contains('City not found')
                          ? 'City not found. Please try again.'
                          : 'An error occurred. Please try again.',
                      style: GoogleFonts.amaranth(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () {
              return ShimmeringWeatherCards();
            },
          );
        },
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
