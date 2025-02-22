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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: fiveDayForecastAt12PM.length,
        itemBuilder: (context, index) {
          final tempCelsius = fiveDayForecastAt12PM[index].main.temp;
          DateTime dateTime =
              DateTime.parse(fiveDayForecastAt12PM[index].dt_txt);

          String formattedDate = DateFormat('E, d MMM').format(dateTime);

          String iconCode = fiveDayForecastAt12PM[index].weather[0].icon;
          final imageUrl = getWeatherIcons(iconCode);

          String description =
              fiveDayForecastAt12PM[index].weather[0].description;

          String capitalizedDescription =
              description[0].toUpperCase() + description.substring(1);

          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100, // Adjust the width as needed
              height: 150, // Adjust the height as needed
              child: Stack(
                children: [
                  // Position the date text
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Text(
                      formattedDate,
                      style: textStyle(14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Positioned(
                    top: 15,
                    left: 0,
                    right: 0,
                    child: Divider(
                      color: Colors.white.withOpacity(0.3),
                      thickness: 1,
                      endIndent: 10,
                      indent: 10,
                    ),
                  ),

                  // Position the image
                  Positioned(
                    top: height * 0.0455,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      imageUrl,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Position the description text
                  Positioned(
                    top: height * 0.147,
                    left: 0,
                    right: 0,
                    child: Text(
                      capitalizedDescription,
                      style: textStyle(16),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),

                  // Position the temperature text
                  Positioned(
                    top: height * 0.18,
                    left: 0,
                    right: 0,
                    child: shadeMask(
                      widget: Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${tempCelsius.toCelsius.round()}',
                                style: textStyle(16),
                              ),
                              TextSpan(
                                text: 'C',
                                style: textStyle(14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: height * 0.177,
                    left: width * 0.15,
                    child: shadeMask(
                      widget: Text(
                        '°',
                        style: textStyle(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
