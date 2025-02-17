import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_pod/features/weather/data/riverpod/fetch_weather.dart';
import 'package:weather_pod/features/weather/presentation/widgets/current_weather_card.dart';
import 'package:weather_pod/features/weather/presentation/widgets/five_day_forecast.dart';
import 'package:weather_pod/features/weather/presentation/widgets/next_hours_forecast.dart';
import 'package:weather_pod/features/weather/presentation/widgets/title_cards.dart';
import 'package:weather_pod/features/weather/utils/constant.dart';
import 'package:weather_pod/features/weather/utils/extention.dart';
import 'package:weather_pod/features/weather/utils/shimmers/shimmering_appbar.dart';
import 'package:weather_pod/features/weather/utils/shimmers/shimmering_weather_cards.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Scaffold(
        backgroundColor: Color(0xF5F5F5F5),
        appBar: _appBar(),
        body: Consumer(
          builder: (context, ref, child) {
            final weather = ref.watch(
              locationWeatherProvider(
                _currentPosition ?? _defaultPosition(),
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

                //use next times Container
                // Filter data to include only today and tomorrow
                final nextHoursfilteredList = data.list.where((entry) {
                  DateTime entryDate = DateTime.parse(entry.dt_txt);
                  return entryDate
                          .isAfter(today.subtract(Duration(seconds: 1))) &&
                      entryDate.isBefore(tomorrow.add(Duration(days: 1)));
                }).toList();

                //use in next days container
                // Filter data to include only today and tomorrow
                // Filter data to show only 12:00 PM (noon) entries
                final fiveDayForecastAt12PM = data.list.where((entry) {
                  DateTime entryDateTimee = DateTime.parse(entry.dt_txt);
                  return entryDateTimee.hour ==
                      12; // Select only entries at 12 PM
                }).toList();

                return RefreshIndicator(
                  color: Colors.deepOrange,
                  onRefresh: () async {
                    await Future.wait([
                      _getCurrentLocation(),
                    ]);
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CurrentWeatherCard(
                          tempCelsius:
                              tempCelsius(listElement.main.temp.toCelsius),
                          description: capitalizedDescription,
                          imageUrl: imageUrl,
                          formattedDate: formattedDate(dateTime),
                          tempMinCelsius:
                              tempCelsius(listElement.main.temp_min.toCelsius),
                          tempMaxCelsius:
                              tempCelsius(listElement.main.temp_max.toCelsius),
                          windSpeed: windSpeed,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TitleCards(title: 'Next Hours'),
                        //next times Container
                        NextHoursForecast(
                            nextHoursfilteredList: nextHoursfilteredList),

                        SizedBox(
                          height: 10,
                        ),
                        TitleCards(title: 'Five Day Forecast'),
                        // Next Days
                        FiveDayForecast(
                          fiveDayForecastAt12PM: fiveDayForecastAt12PM,
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
                        color: Colors.deepOrange,
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

  Position _defaultPosition() {
    return Position(
      latitude: 0,
      longitude: 0,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      timestamp: DateTime.now(),
      altitudeAccuracy: 0,
      headingAccuracy: 0,
      speedAccuracy: 0,
      floor: 0,
    );
  }

  AppBar _appBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Color(0xF5F5F5F5),
      title: Row(
        children: [
          Image.asset(
            'assets/icons/appbar/location.png',
            scale: 14,
          ),
          SizedBox(
            width: 5,
          ),
          Consumer(
            builder: (context, ref, child) {
              if (_currentPosition == null) {
                return SizedBox();
              } else {
                final weather =
                    ref.watch(locationWeatherProvider(_currentPosition!));
                return weather.when(
                  data: (data) {
                    return Text(
                      data.city.name,
                      style: GoogleFonts.amaranth(
                        textStyle: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 23,
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) => Text(
                    error.toString().contains('City not found')
                        ? 'City not found. Please try again.'
                        : 'An error occurred. Please try again.',
                    style: TextStyle(color: Colors.orange),
                  ),
                  loading: () {
                    return ShimmeringAppbar();
                  },
                );
              }
            },
          )
        ],
      ),
      centerTitle: true,
      actions: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/icons/appbar/search.png',
              scale: 14,
            ),
          ),
        ),
      ],
      elevation: 0,
    );
  }
}
