import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/features/weather/utils/style.dart';

class LocationServiceDisable extends StatelessWidget {
    final Future<void> getCurrentLocation;
  const LocationServiceDisable({super.key, required this.getCurrentLocation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 50),
          Lottie.asset(
            'assets/json/location.json', // Path to your JSON file
            width: 330, // Adjust width
            // height: 330, // Adjust height
            fit: BoxFit.contain, // Adjust how the animation fits
            repeat: true, // Set to true if you want the animation to loop
          ),
          Text(
            'Location services are disabled.',
            style: textStyle(blackColor, 18),
          ),
          SizedBox(height: 80),
          ElevatedButton(
            onPressed: () async {
              bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
              if (!serviceEnabled) {
                Geolocator.openLocationSettings();
              }
              await getCurrentLocation;
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: blueColor,
            ),
            child: Text(
              'Enable Location Services',
              style: TextStyle(color: whiteColor),
            ),
          ),
        ],
      ),
    );
  }
}