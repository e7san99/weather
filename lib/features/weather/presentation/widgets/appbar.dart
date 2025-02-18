import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_pod/features/weather/data/riverpod/fetch_weather.dart';
import 'package:weather_pod/features/weather/utils/shimmers/shimmering_appbar.dart';

class AppbarHomePage extends StatelessWidget implements PreferredSizeWidget {
  final Position? currentPosition;
  const AppbarHomePage({super.key, required this.currentPosition});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Color(0xF5F5F5F5),
      title: Row(
        children: [
          Image.asset(
            'assets/icons/appbar/location.png',
            scale: 14,
            color: Colors.blue,
          ),
          SizedBox(
            width: 5,
          ),
          Consumer(
            builder: (context, ref, child) {
              if (currentPosition == null) {
                return SizedBox();
              } else {
                final weather =
                    ref.watch(locationWeatherProvider(currentPosition!));
                return weather.when(
                  data: (data) {
                    return Text(
                      data.city.name,
                      style: GoogleFonts.amaranth(
                        textStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 23,
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) => Text(
                    error.toString().contains('City not found')
                        ? 'City not found. Please try again.'
                        : 'An error occurred. Please try again.',
                    style: TextStyle(color: Colors.blue),
                  ),
                  loading: () {
                    return ShimmeringAppbar();
                  },
                );
              }
            },
          )
        ],
      ),
      centerTitle: true,
      actions: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/icons/appbar/search.png',
              scale: 14,
            ),
          ),
        ),
      ],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
