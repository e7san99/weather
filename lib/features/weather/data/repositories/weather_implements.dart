import 'package:dio/dio.dart';
import 'package:weather_pod/features/weather/data/repositories/weather_repository.dart';
import 'package:weather_pod/features/weather/model/weather.dart';
import 'package:weather_pod/features/weather/utils/constants/http.dart';

class WeatherImplements extends WeatherRepository {

  @override
  Future<WeatherModel> fetchWeatherByCity(String? city) async {
    final dio = Dio();
    try {
      var response = await dio.get(
        '$baseUrl?q=$city&appid=$apiKey',
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
        '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey',
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
