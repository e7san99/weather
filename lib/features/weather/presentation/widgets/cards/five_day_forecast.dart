import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_pod/features/weather/model/weather.dart';
import 'package:weather_pod/features/weather/presentation/widgets/cards/weather_card_container.dart';
import 'package:weather_pod/features/weather/utils/constants/const.dart';
import 'package:weather_pod/features/weather/utils/extention.dart';
import 'package:weather_pod/features/weather/utils/style.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          // scrollDirection: Axis.horizontal,
          itemCount: fiveDayForecastAt12PM.length,
          itemBuilder: (context, index) {
            final tempCelsius = fiveDayForecastAt12PM[index].main.temp;
            DateTime dateTime =
                DateTime.parse(fiveDayForecastAt12PM[index].dt_txt);

            String formattedDate = DateFormat('E, d MMM').format(dateTime);

            String iconCode = fiveDayForecastAt12PM[index].weather[0].icon;
            final imageUrl = getWeatherIcons(iconCode);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    formattedDate,
                    style: textStyle(14),
                  ),
                ),
                Image.asset(
                  imageUrl,
                  height: 40,
                  fit: BoxFit.fill,
                  // color: whiteColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${tempCelsius.toCelsius.round()}°',
                    style: textStyle(16),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
