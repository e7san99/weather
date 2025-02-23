import 'dart:async'; // Import Timer

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_pod/app.dart';
import 'package:weather_pod/features/weather/model/weather.dart';
import 'package:weather_pod/features/weather/utils/constants/http.dart';
import 'package:weather_pod/features/weather/utils/extention.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request notification permission
  await requestNotificationPermission();

  // Initialize notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Test notification immediately
  await _fetchWeatherAndNotify();

  // Start periodic weather fetching
  Timer.periodic(Duration(seconds: 10), (timer) async {
    await _fetchWeatherAndNotify();
  });

  runApp(ProviderScope(child: App()));
}

Future<void> _fetchWeatherAndNotify() async {
  final dio = Dio();
  try {
    var response = await dio.get(
      '$baseUrl?q=Sulaymaniyah&appid=$apiKey', // Replace with your city name
      options: Options(
        method: 'GET',
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final weatherModel = WeatherModel.fromMap(data);

      // Find the temperature at 6:00 PM
      final sixPmWeather = weatherModel.list.firstWhere(
        (element) => element.dt_txt.contains('21:00:00'),
        orElse: () => throw StateError(
            'No element found with dt_txt containing "21:00:00"'),
      );

      final tempCelsius = sixPmWeather.main.temp.toCelsius;

      // Send notification
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'weather_updates_channel', // Channel ID (must be unique)
        'Weather Updates', // Channel name (visible to the user)
        channelDescription: 'Notifications for weather updates at 9:00 PM',
        importance: Importance.max,
        priority: Priority.high,
      );

      const DarwinNotificationDetails darwinPlatformChannelSpecifics =
          DarwinNotificationDetails();

      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: darwinPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        'Weather Update',
        'Temperature at 9:00 PM: ${tempCelsius.toCelsius.round()}°C',
        platformChannelSpecifics,
      );
      print('Notification sent: Temperature at 9:00 PM: $tempCelsius°C');
    }
  } catch (e) {
    print('Error fetching weather data: $e');
  }
}
