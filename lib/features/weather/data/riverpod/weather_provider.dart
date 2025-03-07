import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/features/weather/model/weather.dart';
import 'package:weather/features/weather/data/repositories/repositories.dart';

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

final locationServiceStatusProvider = StateProvider<bool>((ref) => false);

final currentPositionProvider = StateProvider<Position?>((ref) => null);

final isTextfieldEmptyProvider = StateProvider<bool>((ref) => false);
