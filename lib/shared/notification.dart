import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/features/weather/data/repositories/repositories.dart';
import 'package:weather/features/weather/model/weather.dart';
import 'package:weather/utils/utils.dart';

class NotificationScheduler {
  final WeatherRepository _weatherRepository;

  NotificationScheduler(this._weatherRepository);

  static Future<void> scheduleNotifications() async {
    // Initialize Weather Repository
    final weatherRepository = WeatherImplements();

    // Initialize Notification Scheduler
    final notificationScheduler = NotificationScheduler(weatherRepository);

    // Schedule Daily Notifications
    await notificationScheduler._scheduleDailyNotification();
  }

  Future<void> _scheduleDailyNotification() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );

      final weatherModel = await _weatherRepository.fetchWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      final tempCelsius = weatherModel.list.first.main.temp.toCelsius;

      //AM Notifications
      await _showNotifications(1, 12, tempCelsius, weatherModel); // 9 AM
      //PM Notifications
      await _showNotifications(2, 21, tempCelsius, weatherModel); // 9 PM
    
    } catch (e) {
      print('Failed to schedule notifications: $e');
    }
  }

  Future<void> _showNotifications(
    int id,
    int hour,
    double tempCelsius,
    WeatherModel weatherModel,
  ) async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'alerts',
        title: '${tempCelsius.round()}° in ${weatherModel.city.name}',
        body:
            '${weatherModel.list.first.weather[0].description} ~ See full forecast',
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar(
        timeZone: localTimeZone,
        hour: hour,
        minute: 15, //0
        second: 0,
        repeats: true,
      ),
    );
  }

  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
    null, // Use the default icon
    [
      NotificationChannel(
        channelKey: 'alerts',
        channelName: 'Alerts',
        channelDescription: 'Notification weather as alerts',
        playSound: true,
        onlyAlertOnce: true,
        groupAlertBehavior: GroupAlertBehavior.Children,
        importance: NotificationImportance.Max,
        defaultPrivacy: NotificationPrivacy.Public,
        defaultColor: blueColor,
        ledColor: whiteColor,
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      ),
    ],
  );
  }
}