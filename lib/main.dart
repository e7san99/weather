import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/app.dart';
import 'package:weather/shared/notification.dart';
import 'package:weather/utils/notification_permission.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // For newer Android versions,
  //it is necessary to request notification permissions like this:
  await requestNotificationPermission();

  // bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  // if (!isAllowed) {
  //   await AwesomeNotifications().requestPermissionToSendNotifications();
  // }

  await AwesomeNotifications().requestPermissionToSendNotifications();

  // Initialize Awesome Notifications
  await NotificationScheduler.initialize();

  // Schedule notifications
  await NotificationScheduler.scheduleNotifications();

  runApp(ProviderScope(child: App()));
}

//new work is sharedPreferences