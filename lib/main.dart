import 'dart:async'; // Import Timer

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/app.dart';
import 'package:weather/features/weather/model/weather.dart';
import 'package:weather/features/weather/utils/constants/http.dart';
import 'package:weather/features/weather/utils/extention.dart';

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

  // Schedule the notification at 9:00 PM
  scheduleDailyNinePMNotification();

  runApp(ProviderScope(child: App()));
}

void scheduleDailyNinePMNotification() {
  final now = DateTime.now();
  var scheduledTime = DateTime(now.year, now.month, now.day, 14, 20);

  if (scheduledTime.isBefore(now)) {
    scheduledTime = scheduledTime.add(Duration(days: 1));
  }

  final durationUntilNinePM = scheduledTime.difference(now);

  Timer(durationUntilNinePM, () async {
    print('Scheduled time reached, fetching weather data...');
    await _fetchWeatherAndNotify();
    scheduleDailyNinePMNotification();
  });
}

Future<void> _fetchWeatherAndNotify() async {
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

      final sixPmWeather = weatherModel.list.firstWhere(
        (element) => element.dt_txt.contains('12:00:00'),
        orElse: () => throw StateError('No element found with dt_txt containing "12:00:00"'),
      );

      final tempCelsius = sixPmWeather.main.temp.toCelsius;

      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'weather_updates_channel',
        'Weather Updates',
        channelDescription: 'Notifications for weather updates at 9:00 PM',
        importance: Importance.max,
        priority: Priority.high,
      );

      const DarwinNotificationDetails darwinPlatformChannelSpecifics = DarwinNotificationDetails();

      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: darwinPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        'Weather Update',
        'Temperature at 12:00 PM: ${tempCelsius.round()}°C',
        platformChannelSpecifics,
      );
      print('Notification sent: Temperature at 12:00 PM: ${tempCelsius.round()}°C');
    }
  } catch (e) {
    print('Error fetching weather data: $e');
  }
}