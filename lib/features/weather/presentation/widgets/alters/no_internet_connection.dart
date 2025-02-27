import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/features/weather/utils/style.dart';

class NoInternetConnection extends StatelessWidget {
  final Future<void> getCurrentLocation;
  const NoInternetConnection({super.key, required this.getCurrentLocation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
          ),
          Lottie.asset(
            'assets/json/no-internet.json', // Path to your JSON file
            width: 150, // Adjust width
            height: 150, // Adjust height
            fit: BoxFit.contain, // Adjust how the animation fits
            repeat: true, // Set to true if you want the animation to loop
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            'No Internet Connection',
            style: textStyle(blackColor, 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // You can add logic to retry checking the internet connection
              getCurrentLocation;
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: blueColor,
            ),
            child: Text(
              'Retry',
              style: TextStyle(color: whiteColor),
            ),
          ),
        ],
      ),
    );
  }
}
