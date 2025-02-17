import 'package:dio/dio.dart';
import 'package:weather_pod/features/weather/data/repositories/weather_repository.dart';
import 'package:weather_pod/features/weather/model/weather.dart';

class WeatherImplements extends WeatherRepository {
  static const String _apiKey = '2374fcc35708ce98a9a9c84993a40723';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/forecast';

  @override
  Future<WeatherModel> fetchWeatherByCity(String? city) async {
    final dio = Dio();
    try {
      var response = await dio.get(
        '$_baseUrl?q=$city&appid=$_apiKey',
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return WeatherModel.fromMap(data);
      } else {
        throw Exception('Failed to load data: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception('Failed to load data: ${e.message}');
      }
    }
  }

  @override
  Future<WeatherModel> fetchWeatherByLocation(double lat, double lon) async {
    final dio = Dio();
    try {
      var response = await dio.get(
        '$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey',
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return WeatherModel.fromMap(data);
      } else {
        throw Exception('Failed to load data: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load data: ${e.message}');
    }
  }
}
