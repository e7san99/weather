import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/features/weather/data/riverpod/weather_provider.dart';
import 'package:weather/features/weather/presentation/screens/home.dart';
import 'package:weather/features/weather/presentation/widgets/alters/location_service_disable.dart';
import 'package:weather/utils/utils.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    // Fetch the current location when the app starts
    getCurrentLocation(ref);
  }

  @override
  Widget build(BuildContext context) {
    // Check if location services are disabled
    if (ref.watch(locationServiceStatusProvider)) {
      return MaterialApp(
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        title: 'Weather',
        home: LocationServiceDisable(getCurrentLocation: getCurrentLocation(ref)),
      );
    }

    // Watch the current location and weather data
    // final currentLocation = ref.watch(useCurrentLocationProvider);
    // final currentPosition = ref.read(currentPositionProvider);

    // final weather = currentLocation
    //     ? ref.watch(locationWeatherProvider(currentPosition ?? defaultPosition()))
    //     : ref.watch(weatherProvider(ref.watch(cityProvider)));

        // Show loading animation while fetching initial data
    final weather = ref.watch(weatherProvider(ref.watch(cityProvider)));

    return weather.when(
      data: (data) {
        return MaterialApp(
          theme: ThemeData(useMaterial3: true),
          debugShowCheckedModeBanner: false,
          title: 'Weather',
          home:  LocationServiceDisable(getCurrentLocation:  getCurrentLocation(ref)),
        );
      },
      error: (error, stackTrace) {
        return MaterialApp(
          theme: ThemeData(useMaterial3: true),
          debugShowCheckedModeBanner: false,
          title: 'Weather',
          home: HomeScreen()
        );
      },
      loading: () {
        return MaterialApp(
          theme: ThemeData(useMaterial3: true),
          debugShowCheckedModeBanner: false,
          title: 'Weather',
          home: Scaffold(
            body: Center(
            child: Lottie.asset('assets/json/loading.json'),
          ),
          ),
        );
      },
    );
  }
}