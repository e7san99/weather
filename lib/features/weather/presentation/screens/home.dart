import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/features/weather/data/riverpod/riverpod.dart';
import 'package:weather/features/weather/presentation/widgets/widgets.dart';
import 'package:weather/utils/utils.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCityName();
    getCurrentLocation(ref);
  }

  Future<void> _initializeCityName() async {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    final cityName = await sharedPreferences.getCityName();
    ref.read(cityProvider.notifier).state = cityName;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getCurrentLocation(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final internetConnectionStatus = ref.watch(internetConnectionProvider);
    //the current position should be ref.read , becuase it will be updated
    final currentPosition = ref.read(currentPositionProvider);

    final currentLocation = ref.watch(useCurrentLocationProvider);

    if (ref.watch(locationServiceStatusProvider)) {
      return LocationServiceDisable(
        getCurrentLocation: getCurrentLocation(ref),
      );
    }

    final weather =
        currentLocation
            ? ref.watch(
              locationWeatherProvider(currentPosition ?? defaultPosition()),
            )
            : ref.watch(weatherProvider(ref.watch(cityProvider)));

    return Scaffold(
      backgroundColor: Color(0xF5F5F5F5),
      appBar: AppbarHomePage(
        currentPosition: currentPosition,
        searchController: _searchController,
      ),
      body: internetConnectionStatus.when(
        data: (isConnected) {
          if (!isConnected) {
            return NoInternetConnection(
              getCurrentLocation: getCurrentLocation(ref),
            );
          }

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
                color: blueColor,
                onRefresh: () async {
                  await Future.wait([getCurrentLocation(ref)]);
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MainWeatherCard(
                        tempCelsius: listElement.main.temp.toCelsius,
                        description: capitalizedDescription,
                        imageUrl: imageUrl,
                        formattedDate: formattedDate(dateTime),
                        tempMinCelsius: listElement.main.temp_min.toCelsius,
                        tempMaxCelsius: listElement.main.temp_max.toCelsius,
                        windSpeed: windSpeed,
                      ),
                      SizedBox(height: 10),
                      _titleCard('Next Hours'),
                      NextHoursForecast(nextHoursfilteredList: nextHours),
                      SizedBox(height: 10),
                      _titleCard('Five Day Forecast'),
                      FiveDayForecast(fiveDayForecastAt12PM: fiveDayForecast),
                    ],
                  ),
                ),
              );
            },
            error: (error, stackTrace) {
              // Check if the error is a "city not found" error
              if (error.toString().contains('City not found')) {
                return CityNotFound(
                  searchController: _searchController,
                  error: error,
                );
              } else if (error.toString().contains(
                'Failed to load data: The connection errored',
              )) {
                // Handle connection error (e.g., no internet)
                return NoInternetConnection(
                  getCurrentLocation: getCurrentLocation(ref),
                );
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
          return SizedBox();
          //return Center(child: CircularProgressIndicator(color: Colors.green,));
        },
      ),
    );
  }

  Padding _titleCard(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(children: [Text(title, style: textStyle(blueColor, 20))]),
    );
  }
}
