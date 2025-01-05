import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:weather_pod/features/weather/data/repositories/weather_repository.dart';
import 'package:weather_pod/features/weather/model/weather.dart';

class WeatherImplements extends WeatherRepository {
  static const String _apiKey = '2374fcc35708ce98a9a9c84993a40723';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/forecast';

  @override
  Future<SingleOrderModel> fetchWeatherByCity(String? city) async {
    final dio = Dio();
    var response = await dio.get(
      '$_baseUrl?q=$city&appid=$_apiKey',
      options: Options(
        method: 'GET',
      ),
    );

    if (response.statusCode == 200) {
      print(response.data); // Debugging

      // // Extract the temperature values from the "list" array
      // final List<dynamic> weatherList = data['list'];
      // final List<double> temperatures = weatherList.map((item) {
      //   return item['main']['temp'] as double;
      // }).toList();

      // return temperatures;

      final data = response.data as Map<String, dynamic>;
      // json.decode(data);
      final city = data['city']['name'];

      return SingleOrderModel.fromMap(data);
    } else {
      print(response.statusMessage); // Debugging
      throw Exception('Failed to load data');
    }
  }
}
