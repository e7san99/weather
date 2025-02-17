import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_pod/features/weather/model/weather.dart';
import 'package:weather_pod/features/weather/presentation/widgets/container.dart';
import 'package:weather_pod/features/weather/utils/constants/constant.dart';
import 'package:weather_pod/features/weather/utils/constants/style.dart';
import 'package:weather_pod/features/weather/utils/extention/extention.dart';

class NextDays extends StatelessWidget {
  final List<ListElement> filteredListFor12PmNextDays;
  const NextDays({
    super.key,
    required this.filteredListFor12PmNextDays,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;
    return CustomContainer(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          // scrollDirection: Axis.horizontal,
          itemCount: filteredListFor12PmNextDays.length,
          itemBuilder: (context, index) {
            final tempCelsius = filteredListFor12PmNextDays[index].main.temp;
            DateTime dateTimee =
                DateTime.parse(filteredListFor12PmNextDays[index].dt_txt);

            // Format the date as "Sat"
            String formattedDate = DateFormat('E').format(dateTimee);

            String iconCode =
                filteredListFor12PmNextDays[index].weather[0].icon;
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
                    style: textStyle(14),
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
