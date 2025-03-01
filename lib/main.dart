import 'dart:async'; // Import Timer

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/app.dart';
import 'package:weather/features/weather/model/weather.dart';
import 'package:weather/features/weather/utils/constants/const.dart';
import 'package:weather/features/weather/utils/constants/http.dart';
import 'package:weather/features/weather/utils/extention.dart';



Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

Future<void> requestPermissions() async {
  await [
    Permission.location,
    Permission.notification,
    Permission.scheduleExactAlarm,
  ].request();
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await requestPermissions();
  await requestNotificationPermission();

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

      final sixPmWeather = weatherModel.list.firstWhere(
        (element) => element.dt_txt.contains('12:00:00'),
        orElse:
            () =>
                throw StateError(
                  'No element found with dt_txt containing "12:00:00"',
                ),
      );

      final tempCelsius = sixPmWeather.main.temp.toCelsius;
      String iconCode = sixPmWeather.weather[0].icon;
      String imageUrl = getWeatherIcons(iconCode);

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: 'Daily Notification',
          body: 'Temperature at 12:00 PM: ${tempCelsius.round()}°C',
        ),
        schedule: NotificationCalendar(
          hour: 23, // 9 PM
          minute: 42,
          second: 0,
          repeats: true, // Repeat daily
        ),
      );

      print(
        'Notification sent: Temperature at 12:00 PM: ${tempCelsius.round()}°C',
      );
    }
  } catch (e) {
    print(e);
  }
}
