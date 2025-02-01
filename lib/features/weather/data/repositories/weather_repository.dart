import 'package:weather_pod/features/weather/model/weather.dart';

abstract class WeatherRepository {
  Future<SingleOrderModel> fetchWeatherByCity(String? city);
  Future<SingleOrderModel> fetchWeatherByLocation(double lat, double lon);
}
