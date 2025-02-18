import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    // Use `WidgetsBinding.instance.addPostFrameCallback` to access `ref` after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation(); // Pass `ref` to the method
    });
  }

  Future<void> _getCurrentLocation({WidgetRef? ref}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      ref?.read(isLocationServiceEnabledProvider.notifier).state =
          false; // Update state
      return;
    }

    ref?.read(isLocationServiceEnabledProvider.notifier).state =
        true; // Update state

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
        appBar: AppbarHomePage(currentPosition: _currentPosition),
        body: Consumer(
          builder: (context, ref, child) {
            // Use `ref` here as needed
            final isLocationServiceEnabled =
                ref.watch(isLocationServiceEnabledProvider);

            if (!isLocationServiceEnabled) {
              return _locationServiceDisable(ref);
            }

            final weather = ref.watch(
              locationWeatherProvider(
                _currentPosition ?? defaultPosition(),
              ),
            );

            return weather.when(
              data: (data) {
                //use in base container
                //tempCelsius
                final listElement = data.list[0];

                //date
                DateTime dateTime = DateTime.parse(listElement.dt_txt);

                //description
                String description = listElement.weather[0].description;
                String capitalizedDescription =
                    description[0].toUpperCase() + description.substring(1);

                //wind speed
                double windSpeed = listElement.wind.speed;

                String iconCode = listElement.weather[0].icon;
                String imageUrl = getWeatherIcons(iconCode);

                // Filter data to include only today and tomorrow
                final nextHours = nextHoursfilteredList(data.list);

                // Filter data to include only today and tomorrow
                // Filter data to show only 12:00 PM (noon) entries
                final fiveDayForecast = fiveDayForecastAt12PM(data.list);

                return RefreshIndicator(
                  color: Colors.blue,
                  onRefresh: () async {
                    await Future.wait([_getCurrentLocation(ref: ref)]);
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
                        SizedBox(
                          height: 10,
                        ),
                        TitleCards(title: 'Next Hours'),
                        //next times Container
                        NextHoursForecast(nextHoursfilteredList: nextHours),

                        SizedBox(
                          height: 10,
                        ),
                        TitleCards(title: 'Five Day Forecast'),
                        // Next Days
                        FiveDayForecast(
                          fiveDayForecastAt12PM: fiveDayForecast,
                        ),
                      ],
                    ),
                  ),
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text(
                    error.toString().contains('City not found')
                        ? 'City not found. Please try again.'
                        : 'An error occurred. Please try again.',
                    style: GoogleFonts.amaranth(
                      textStyle: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              },
              loading: () {
                return ShimmeringWeatherCards();
              },
            );
          },
        ));
  }

  RefreshIndicator _locationServiceDisable(WidgetRef ref) {
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: () async => _getCurrentLocation(ref: ref),
      child: SingleChildScrollView(
        // Add this
        physics:
            AlwaysScrollableScrollPhysics(), // Ensure it's always scrollable
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/icons/map.png',
                scale: 3,
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
                  bool serviceEnabled =
                      await Geolocator.isLocationServiceEnabled();
                  if (!serviceEnabled) {
                    Geolocator.openLocationSettings();
                  }
                  await _getCurrentLocation(ref: ref);
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
        ),
      ),
    );
  }
}
