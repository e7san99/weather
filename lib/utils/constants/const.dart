import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/features/weather/model/weather.dart';

Position defaultPosition() {
  return Position(
    latitude: 0,
    longitude: 0,
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    timestamp: DateTime.now(),
    altitudeAccuracy: 0,
    headingAccuracy: 0,
    speedAccuracy: 0,
    floor: 0,
  );
}

String formattedDate(DateTime dateTime) {
  return DateFormat('EEEE, d MMM').format(dateTime);
}

DateTime now = DateTime.now();
DateTime today = DateTime(now.year, now.month, now.day);
DateTime tomorrow = today.add(Duration(days: 1));

// Function to filter the list to get entries between today and tomorrow
List<ListElement> nextHoursfilteredList(List<ListElement> list) {
  return list.where((entry) {
    DateTime entryDate = DateTime.parse(entry.dt_txt);
    return entryDate.isAfter(today.subtract(Duration(seconds: 1))) &&
        entryDate.isBefore(tomorrow.add(Duration(days: 1)));
  }).toList();
}

// Function to filter the list to get entries at 12 PM
List<ListElement> fiveDayForecastAt12PM(List<ListElement> list) {
  return list.where((entry) {
    DateTime entryDateTimee = DateTime.parse(entry.dt_txt);
    return entryDateTimee.hour == 12; // Select only entries at 12 PM
  }).toList();
}



String getWeatherIcons(String iconCode) {
  String imageUrl;
  switch (iconCode) {
    //icon of the day
    case '01d':
      imageUrl = 'assets/icons/01d.png';
      break;
    case '02d':
      imageUrl = 'assets/icons/02d.png';
      break;
    case '03d':
      imageUrl = 'assets/icons/03d.png';
      break;
    case '04d':
      imageUrl = 'assets/icons/04d.png';
      break;
    case '09d':
      imageUrl = 'assets/icons/09d.png';
      break;
    case '10d':
      imageUrl = 'assets/icons/10d.png';
      break;
    case '11d':
      imageUrl = 'assets/icons/11d.png';
      break;
    case '13d':
      imageUrl = 'assets/icons/13d.png';
      break;
    case '50d':
      imageUrl = 'assets/icons/50d.png';
      break;
    default:
      imageUrl = 'assets/icons/03d.png';
      break;
  }
  return imageUrl;
}
