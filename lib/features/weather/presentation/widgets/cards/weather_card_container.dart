// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

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
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          tileMode: TileMode.mirror,
          colors: [
            // Colors.orange,
            // Colors.deepOrange,
            // Colors.deepOrangeAccent,
            Colors.lightBlue,
            Colors.blueAccent,
            Colors.blue,
          ],
        ),
      ),
      child: child,
    );
  }
}
