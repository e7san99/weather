import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_pod/features/weather/presentation/widgets/weather_card_container.dart';
import 'package:weather_pod/features/weather/utils/constants/constant.dart';
import 'package:weather_pod/features/weather/utils/constants/style.dart';
import 'package:weather_pod/features/weather/utils/extention/extention.dart';

class NextHoursForecast extends StatelessWidget {
  final List nextHoursfilteredList;

  const NextHoursForecast({super.key, required this.nextHoursfilteredList});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;
    return WeatherCardContainer(
      height: height * 0.8,
      width: width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: nextHoursfilteredList.length,
        itemBuilder: (context, index) {
          final item = nextHoursfilteredList[index];
          final double tempCelsiuss = nextHoursfilteredList[index].main.temp;
          DateTime dateTimee =
              DateTime.parse(nextHoursfilteredList[index].dt_txt);

          String formattedDate = DateFormat.jm().format(dateTimee);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formattedDate,
                  style: textStyle(16),
                ),
                SizedBox(
                  height: 8,
                ),
                Image.asset(getWeatherIcons(item.weather[0].icon), height: 60),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '${tempCelsiuss.toCelsius.round()}°',
                  style: textStyle(18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
