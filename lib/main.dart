import 'dart:async'; // Import Timer

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:weather/app.dart';
import 'package:weather/features/weather/model/weather.dart';
import 'package:weather/features/weather/utils/constants/const.dart';
import 'package:weather/features/weather/utils/constants/http.dart';
import 'package:weather/features/weather/utils/extention.dart';



// Future<void> requestNotificationPermission() async {
//   if (await Permission.notification.isDenied) {
//     await Permission.notification.request();
//   }
// }

// Future<void> requestPermissions() async {
//   await [
//     Permission.location,
//     Permission.notification,
//     Permission.scheduleExactAlarm,
//   ].request();
// }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await requestPermissions();
  // await requestNotificationPermission();

  // Initialize Awesome Notifications
  await AwesomeNotifications().initialize(
    null, // Use the default icon
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        importance: NotificationImportance.High,
        defaultColor: Colors.blue,
        ledColor: Colors.white,
      ),
    ],
  );

  // Request permission to send notifications
  await AwesomeNotifications().requestPermissionToSendNotifications();

  // Schedule a daily notification at 9 PM
  await _scheduleDailyNotification();

  runApp(ProviderScope(child: App()));
}

Future<void> _scheduleDailyNotification() async {
  final dio = Dio();

  Position position;
  try {
    position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    );
  } catch (e) {
    print('Error getting location: $e');
    return;
  }
  try {
    var response = await dio.get(
      '$baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey',
      options: Options(method: 'GET'),
    );
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final weatherModel = WeatherModel.fromMap(data);


      // Get the current weather data (first element in the list)
      final currentWeather = weatherModel.list[0];

      final tempCelsius = currentWeather.main.temp.toCelsius;
      // String iconCode = currentWeather.weather[0].icon;
      // String imageUrl = getWeatherIcons(iconCode);

      await _showNotifications(1,0,tempCelsius, weatherModel); //0AM
      await _showNotifications(2,9,tempCelsius, weatherModel); //9AM
      await _showNotifications(3,12,tempCelsius, weatherModel); //12 PM
      await _showNotifications(4,15,tempCelsius, weatherModel); //3 PM
      await _showNotifications(5,18,tempCelsius, weatherModel); //6 PM
      await _showNotifications(6,21,tempCelsius, weatherModel); //9 PM
      

      print(
        'Notification sent: Temperature at 12:00 PM: ${tempCelsius.round()}°C',
      );
    }
  } catch (e) {
    print(e);
  }
}

Future<void> _showNotifications(
  int id, int hour,double tempCelsius, WeatherModel weatherModel,
) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'basic_channel',
      title: '${tempCelsius.round()}° in ${weatherModel.city.name}',
      body: '${weatherModel.list.first.weather[0].description} ~ See full forecast',
    ),
    schedule: NotificationCalendar(
      hour: hour, // 10AM
      minute: 0,
      second: 0,
      repeats: true, // Repeat daily
    ),
  );
}
