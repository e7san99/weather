// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/features/weather/data/repositories/weather_implements.dart';
import 'package:weather/features/weather/data/repositories/weather_repository.dart';
import 'package:weather/features/weather/model/weather.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherImplements(),
);

final weatherProvider = FutureProvider.family<WeatherModel, String>((
  ref,
  city,
) async {
  final weatherRepository = ref.read(weatherRepositoryProvider);
  return await weatherRepository.fetchWeatherByCity(city);
});

// String city = '';
final cityProvider = StateProvider<String>((ref) => '');

final useCurrentLocationProvider = StateProvider<bool>((ref) => true);

final locationWeatherProvider = FutureProvider.family<WeatherModel, Position>((
  ref,
  position,
) async {
  final weatherRepository = ref.read(weatherRepositoryProvider);
  return await weatherRepository.fetchWeatherByLocation(
    position.latitude,
    position.longitude,
  );
});

//jare amam wastandwa : pause
final nextDaysWeatherProvider = FutureProvider.family<WeatherModel, String>((
  ref,
  city,
) async {
  final weatherRepository = ref.read(weatherRepositoryProvider);
  return await weatherRepository.fetchWeatherByCity(city);
});

// final isLocationServiceEnabledProvider = StateProvider<bool>((ref) => true);

// final internetConnectionProvider = StreamProvider<bool>((ref) {
//   return InternetConnection().onStatusChange.map(
//         (status) => status == InternetStatus.connected,
//       );
// });

// final internetConnectionProvider = FutureProvider<bool>((ref) async {
//   var connectivityResult = await Connectivity().checkConnectivity();
//   return connectivityResult != ConnectivityResult.none;
// });
final internetConnectionProvider = FutureProvider<bool>((ref) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return !connectivityResult.contains(ConnectivityResult.none);
});