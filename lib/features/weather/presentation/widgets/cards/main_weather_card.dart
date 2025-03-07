import 'package:flutter/material.dart';
import 'package:weather/features/weather/presentation/widgets/cards/weather_card_container.dart';
import 'package:weather/features/weather/utils/utils.dart';

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
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;

    return WeatherCardContainer(
      height: height,
      width: width,
      child: Stack(
        children: [
          //Base Icon
          Positioned(
            top: height * 0.02,
            left: width * 0.07,
            child: Image.asset(
              imageUrl,
              height: 100,
              fit: BoxFit.fill,
            ),
          ),
          //Description
          Positioned(
            top: height * 0.166,
            left: width * 0.07,
            child: shadeMask(
              widget: Text(
                description,
                style: textStyle(whiteColor, 25),
              ),
            ),
          ),
          //date
          Positioned(
            top: height * 0.22,
            left: width * 0.07,
            child: Text(
              formattedDate,
              style: textStyle(whiteColor, 16),
            ),
          ),
          //Base Temperature
          Positioned(
              top: height * 0.013,
              right: width * 0.14,
              child: shadeMask(
                widget: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${tempCelsius.round()}',
                        style: textStyle(whiteColor, 72),
                      ),
                      TextSpan(
                        text: 'C',
                        style: textStyle(whiteColor, 60),
                      ),
                    ],
                  ),
                ),
              )),
          //temp dgree °
          Positioned(
            top: height * 0.02,
            right: width * 0.14,
            child: shadeMask(
              widget: Text(
                '°',
                style: textStyle(whiteColor, 47),
              ),
            ),
          ),
          //min max temp
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
                Text('${tempMinCelsius.round()}° / ${tempMaxCelsius.round()}°',
                    style: textStyle(Color(0xE7F1E9E9), 20)),
                Image.asset(
                  'assets/icons/up-arrow.png',
                  scale: 25,
                  color: Color(0xE7F1E9E9),
                )
              ],
            ),
          ),
          //wind speed
          Positioned(
            top: height * 0.22,
            right: width * 0.07,
            child: Text(
              'Wind speed: $windSpeed m/s',
              style: textStyle(whiteColor, 16),
            ),
          ),
          //vertical line
          Positioned(
            top: height * 0.22,
            left: width * 0.451,
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
