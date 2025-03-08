import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/utils/constants/const.dart';
import 'package:weather/features/weather/presentation/widgets/widgets.dart';
class NextHoursForecast extends StatelessWidget {
  final List nextHoursfilteredList;

  const NextHoursForecast({super.key, required this.nextHoursfilteredList});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;

    return WeatherCardContainer(
      height: height * 1,
      width: width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: nextHoursfilteredList.length,
        itemBuilder: (context, index) {
          final item = nextHoursfilteredList[index];
          final double tempCelsius = nextHoursfilteredList[index].main.temp;
          DateTime dateTime = DateTime.parse(nextHoursfilteredList[index].dt_txt);
          String formattedDate = DateFormat.jm().format(dateTime);
          String description = nextHoursfilteredList[index].weather[0].description;
          String capitalizedDescription = description[0].toUpperCase() + description.substring(1);

          return WeatherForecastCard(
            formattedDate: formattedDate,
            imageUrl: getWeatherIcons(item.weather[0].icon),
            description: capitalizedDescription,
            tempCelsius: tempCelsius,
          );
        },
      ),
    );
  }
}