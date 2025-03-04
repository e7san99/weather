
import 'dart:async'; // Import Timer

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/app.dart';
import 'package:weather/features/weather/presentation/widgets/notification.dart';

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

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

  // await Permission.notification.request();
  
  //  // Request notification permissions
  // await requestNotificationPermission();

  await AwesomeNotifications().requestPermissionToSendNotifications();

    


  // Initialize Awesome Notifications
  await AwesomeNotifications().initialize(
    null, // Use the default icon
    [
      NotificationChannel(
        channelKey: 'alerts',
        channelName: 'Alerts',
        channelDescription: 'Notification tests as alerts',
        playSound: true,
        onlyAlertOnce: true,
        groupAlertBehavior: GroupAlertBehavior.Children,
        importance: NotificationImportance.High,
        defaultPrivacy: NotificationPrivacy.Private,
        defaultColor: Colors.blue,
        ledColor: Colors.white,
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      ),
    ],
  );

      // bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
      // if (!isAllowed) {
      //   await AwesomeNotifications().requestPermissionToSendNotifications();
      // } 

  // Schedule a daily notification
  await NotificationScheduler.initializeAndSchedule();


  runApp(ProviderScope(child: App()));
}
