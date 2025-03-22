import 'package:flutter/material.dart';
import 'package:weather/utils/utils.dart';

class WeatherForecastCard extends StatelessWidget {
  final String formattedDate;
  final String imageUrl;
  final String description;
  final double tempCelsius;

  const WeatherForecastCard({
    super.key,
    required this.formattedDate,
    required this.imageUrl,
    required this.description,
    required this.tempCelsius,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;

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
        border: Border.all(color: Colors.white.withOpacity(0.3)),
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
                style: textStyle(whiteColor, 14),
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
              child: Image.asset(imageUrl, height: 60, fit: BoxFit.contain),
            ),

            // Position the description text
            Positioned(
              top: height * 0.147,
              left: 0,
              right: 0,
              child: Text(
                description,
                style: languageTextStyle(
                  context: context,
                  color: whiteColor,
                  fontSize: isKurdish(context) ? 14 : 16,
                ), //textStyle(whiteColor, 16),
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
                          style: textStyle(whiteColor, 16),
                        ),

                        TextSpan(text: 'C', style: textStyle(whiteColor, 14)),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(
                              -3.3,
                              0.9,
                            ), // Adjust the offset to your preference
                            child: Text('°', style: textStyle(whiteColor, 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
