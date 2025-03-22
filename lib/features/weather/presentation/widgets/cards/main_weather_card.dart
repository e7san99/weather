import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weather/features/weather/presentation/widgets/cards/weather_card_container.dart';
import 'package:weather/utils/utils.dart';

class MainWeatherCard extends StatelessWidget {
  final double tempCelsius;
  final String description;
  final String imageUrl;
  final String formattedDate;
  final double tempMinCelsius;
  final double tempMaxCelsius;
  final double windSpeed;

  const MainWeatherCard({
    super.key,
    required this.tempCelsius,
    required this.description,
    required this.imageUrl,
    required this.formattedDate,
    required this.tempMinCelsius,
    required this.tempMaxCelsius,
    required this.windSpeed,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    final DateTime date = DateTime.now();
    final String arFormattedDate = getCustomKurdishDate(
      date,
      context,
    ); // Use the custom function here

    String windSpeedText = 'wind_speed'.tr(
      namedArgs: {'windSpeed': windSpeed.toLocalized(context)},
    );
    return WeatherCardContainer(
      height: height,
      width: width,
      child: Stack(
        children: [
          // Base Icon
          Positioned(
            top: height * 0.02,
            left: width * 0.07,
            child: Image.asset(imageUrl, height: 100, fit: BoxFit.fill),
          ),
          // Description
          Positioned(
            top: height * 0.166,
            left: width * 0.07,
            child: shadeMask(
              widget: Text(
                description.tr(),
                style: languageTextStyle(
                  context: context,
                  color: whiteColor,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          // Date
          Positioned(
            top: height * 0.22,
            left: isKurdish(context) ? width * 0.14 : width * 0.07,
            child: Text(arFormattedDate, style: textStyle(whiteColor, 16)),
          ),
          // Base Temperature
          Positioned(
            top: height * 0.013,
            right: width * 0.14,
            child: shadeMask(
              widget: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: tempCelsius.round().toLocalized(
                        context,
                      ), // Use toLocalized
                      style: textStyle(whiteColor, 72),
                    ),
                    TextSpan(text: 'C', style: textStyle(whiteColor, 60)),
                  ],
                ),
              ),
            ),
          ),
          // Temp degree °
          Positioned(
            top: isKurdish(context) ? height * 0.016 : height * 0.02,
            right: width * 0.14,
            child: shadeMask(
              widget: Text('°', style: textStyle(whiteColor, 47)),
            ),
          ),
          // Min Max Temp
          Positioned(
            top: height * 0.17,
            right: width * 0.06,
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/down-arrow.png',
                  scale: 18,
                  color: const Color(0xE7F1E9E9),
                ),
                Text(
                  '${tempMinCelsius.round().toLocalized(context)}° / ${tempMaxCelsius.round().toLocalized(context)}°', // Use toLocalized
                  style: languageTextStyle(
                    context: context,
                    color: Color(0xE7F1E9E9),
                    fontSize: 20,
                  ),
                  // textStyle(Color(0xE7F1E9E9), 20),
                ),
                Image.asset(
                  'assets/icons/up-arrow.png',
                  scale: 25,
                  color: Color(0xE7F1E9E9),
                ),
              ],
            ),
          ),
          // Wind Speed
          Positioned(
            top: height * 0.22,
            right: width * 0.07,
            child: Text(
              '$windSpeedText: ${windSpeed.toLocalized(context)} ${'meter_second'.tr()}',
              style: languageTextStyle(
                context: context,
                color: whiteColor,
                fontSize: 16,
              ),

              // textStyle(whiteColor, 16),
            ),
          ),
          // Vertical Line
          Positioned(
            top: height * 0.22,
            left: isKurdish(context) ? width * 0.50 : width * 0.451,
            child: Container(
              height: 20, // Adjust the height as needed
              width: 2, // Adjust the width of the vertical line
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

getCustomKurdishDate(DateTime date, BuildContext context) {
  if (context.locale.languageCode == 'ar') {
    final Map<String, String> customMonths = {
      'يناير': 'ڕێبەندان',
      'فبراير': 'ڕەشەمێ',
      'مارس': 'نەورۆز',
      'أبريل': 'گوڵان',
      'مايو': 'جۆزەردان',
      'يونيو': 'پووشپەڕ',
      'يوليو': 'خەرمانان',
      'أغسطس': 'گەلاوێژ',
      'سبتمبر': 'ڕەزبەر',
      'أكتوبر': 'گەڵاڕێزان',
      'نوفمبر': 'سەرماوەز',
      'ديسمبر': 'بەفرانبار',
    };
    final Map<String, String> customWeekdays = {
      'السبت': 'شەممە',
      'الأحد': '١ شەممە',
      'الاثنين': '٢ شەممە',
      'الثلاثاء': '٣ شەممە',
      'الأربعاء': '٤ شەممە',
      'الخميس': '٥ شەممە',
      'الجمعة': 'هەینی',
    };

    final String formattedDate = DateFormat('EEEE, dd MMM', 'ar').format(date);
    String customDate = formattedDate;

    // Replace months
    customMonths.forEach((defaultMonth, customMonth) {
      customDate = customDate.replaceAll(defaultMonth, customMonth);
    });

    // Replace weekdays
    customWeekdays.forEach((defaultWeekday, customWeekday) {
      customDate = customDate.replaceAll(defaultWeekday, customWeekday);
    });

    return customDate;
  } else {
    // Format the date in English (e.g., "Saturday, 22 Mar")
    return DateFormat('EEEE, dd MMM', 'en').format(date);
  }
}

extension NumberExtension on num {
  String toLocalized(BuildContext context) {
    final int roundedValue = round(); // Round the number to the nearest integer
    if (context.locale.languageCode == 'ar') {
      return roundedValue
          .toString()
          .replaceAll('0', '٠')
          .replaceAll('1', '١')
          .replaceAll('2', '٢')
          .replaceAll('3', '٣')
          .replaceAll('4', '٤')
          .replaceAll('5', '٥')
          .replaceAll('6', '٦')
          .replaceAll('7', '٧')
          .replaceAll('8', '٨')
          .replaceAll('9', '٩');
    } else {
      return roundedValue
          .toString(); // Return English numbers for other locales
    }
  }
}

String translateDescription(String description, BuildContext context) {
  if (context.locale.languageCode == 'ar') {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return 'ئاسمانی ڕوناک';
      case 'few clouds':
        return 'هەندێک هەور';
      case 'scattered clouds':
        return 'هەورە بڵاوەکان';
      case 'thunderstorm':
        return 'تۆفان'; // Thunderstorm
      case 'broken clouds':
        return 'هەوری شکاو'; // Thunderstorm
      case 'snow':
        return 'بەفر'; // Snow
      case 'mist':
        return 'تەم'; // Mist
      case 'light rain':
        return 'بارانی سوک'; // Light rain
      case 'heavy rain':
        return 'بارانی قورس'; // Heavy rain
      case 'freezing rain':
        return 'بارانی سەهۆڵ'; // Freezing rain
      case 'hail':
        return 'تەڵەبەفر'; // Hail
      case 'fog':
        return 'تەم'; // Fog
      case 'dust':
        return 'خۆڵ'; // Dust
      case 'sand':
        return 'خۆڵەمەشی'; // Sand
      case 'ash':
        return 'خۆڵەپاش'; // Ash
      case 'squalls':
        return 'باڵەسەبا'; // Squalls
      case 'tornado':
        return 'تۆڕنادۆ'; // Tornado
      default:
        return description; // ئەگەر وەرگێڕان نەدۆزرایەوە، بەهەمان زاراوەی ڕەسەن بمێنێتەوە
    }
  } else {
    return description; // بۆ زمانەکانی تر، زاراوەی ڕەسەن بمێنێتەوە
  }
}
