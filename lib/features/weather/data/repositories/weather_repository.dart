import 'package:weather_pod/features/weather/model/weather.dart';

abstract class WeatherRepository {
  Future<WeatherModel> fetchWeatherByCity(String? city);
  Future<WeatherModel> fetchWeatherByLocation(double lat, double lon);
}
