import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/utils/utils.dart';

class CityNotFound extends StatelessWidget {
  final Object error;
  final TextEditingController searchController;
  const CityNotFound({super.key, required this.searchController,required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Lottie.asset(
            'assets/json/city.json', // Path to your JSON file
            width: 300, // Adjust width
            height: 300, // Adjust height
            fit: BoxFit.contain, // Adjust how the animation fits
            repeat: true, // Set to true if you want the animation to loop
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${searchController.text} ', // City name
                  style: textStyle(blueColor, 18),
                ),
                TextSpan(
                  text: 'not found.', // Error message
                  style: textStyle(blackColor, 18),
                ),
              ],
            ),
          ),
          Text(
            error.toString().contains('City not found')
                ? ' Check the city name and try again!'
                : 'An error occurred. Please try again.',
            style: textStyle(blackColor, 17),
          ),
        ],
      ),
    );
  }
}
