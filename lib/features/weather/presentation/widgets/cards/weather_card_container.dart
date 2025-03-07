import 'package:flutter/material.dart';
import 'package:weather/features/weather/utils/utils.dart';

class WeatherCardContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget? child;
  const WeatherCardContainer({
    super.key,
    required this.height,
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.27,
      margin: EdgeInsets.all(8),
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          tileMode: TileMode.mirror,
          colors: [
            Colors.lightBlue,
            Colors.blueAccent,
            blueColor,
          ],
        ),
      ),
      child: child,
    );
  }
}
