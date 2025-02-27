import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/features/weather/model/weather.dart';
import 'package:weather/features/weather/presentation/widgets/cards/weather_card_container.dart';
import 'package:weather/features/weather/presentation/widgets/cards/weather_forecast_card.dart';
import 'package:weather/features/weather/utils/constants/const.dart';

class FiveDayForecast extends StatelessWidget {
  final List<ListElement> fiveDayForecastAt12PM;

  const FiveDayForecast({
    super.key,
    required this.fiveDayForecastAt12PM,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;

    return WeatherCardContainer(
      height: height,
      width: width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: fiveDayForecastAt12PM.length,
        itemBuilder: (context, index) {
          final tempCelsius = fiveDayForecastAt12PM[index].main.temp;
          DateTime dateTime = DateTime.parse(fiveDayForecastAt12PM[index].dt_txt);
          String formattedDate = DateFormat('E, d MMM').format(dateTime);
          String iconCode = fiveDayForecastAt12PM[index].weather[0].icon;
          final imageUrl = getWeatherIcons(iconCode);
          String description = fiveDayForecastAt12PM[index].weather[0].description;
          String capitalizedDescription = description[0].toUpperCase() + description.substring(1);

          return WeatherForecastCard(
            formattedDate: formattedDate,
            imageUrl: imageUrl,
            description: capitalizedDescription,
            tempCelsius: tempCelsius,
          );
        },
      ),
    );
  }
}