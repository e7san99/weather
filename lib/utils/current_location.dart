// location_utils.dart
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/features/weather/data/riverpod/riverpod.dart';

Future<void> getCurrentLocation(WidgetRef ref) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ref.read(locationServiceStatusProvider.notifier).state = true;
    return;
  }
  ref.read(locationServiceStatusProvider.notifier).state = false;

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
  ref.read(currentPositionProvider.notifier).state = position;
}