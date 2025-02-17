import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_pod/features/weather/data/riverpod/fetch_weather_by_city.dart';
import 'package:weather_pod/features/weather/presentation/widgets/container.dart';
import 'package:weather_pod/features/weather/presentation/widgets/next_times.dart';
import 'package:weather_pod/features/weather/presentation/widgets/weather_details.dart';
import 'package:weather_pod/features/weather/utils/constants/constant.dart';
import 'package:weather_pod/features/weather/utils/extention/extention.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xF5F5F5F5),
        appBar: _appBar(),
        body: Consumer(
          builder: (context, ref, child) {
            final weather =
                ref.watch(locationWeatherProvider(_currentPosition ??
                    Position(
                      latitude: 0,
                      longitude: 0,
                      accuracy: 0,
                      altitude: 0,
                      heading: 0,
                      speed: 0,
                      timestamp: DateTime.now(),
                      altitudeAccuracy: 0,
                      headingAccuracy: 0,
                      speedAccuracy: 0,
                      floor: 0,
                    )));

            return weather.when(
              data: (data) {
                //use in base container
                //tempCelsius
                double tempCelsius = data.list[0].main.temp.toCelsius;
                double tempMinCelsius = data.list[0].main.temp_min.toCelsius;
                double tempMaxCelsius = data.list[0].main.temp_max.toCelsius;
                //date
                DateTime dateTime = DateTime.parse(data.list[0].dt_txt);
                String formattedDate =
                    DateFormat('EEEE, d MMM').format(dateTime);

                //description
                String description = data.list[0].weather[0].description;
                double windSpeed = data.list[0].wind.speed;

                String iconCode = data.list[0].weather[0].icon;
                String imageUrl = getWeatherIcons(iconCode);

                final double width = MediaQuery.sizeOf(context).width;
                final double height = MediaQuery.sizeOf(context).height;

                //use next times Container
                DateTime now = DateTime.now();
                DateTime today = DateTime(now.year, now.month, now.day);
                DateTime tomorrow = today.add(Duration(days: 1));

                // Filter data to include only today and tomorrow
                final nextTimefilteredList = data.list.where((entry) {
                  DateTime entryDate = DateTime.parse(entry.dt_txt);
                  return entryDate
                          .isAfter(today.subtract(Duration(seconds: 1))) &&
                      entryDate.isBefore(tomorrow.add(Duration(days: 1)));
                }).toList();

                //use in next days container
                // Filter data to include only today and tomorrow
                // Filter data to show only 12:00 PM (noon) entries
                final filteredListForNextDays = data.list.where((entry) {
                  DateTime entryDateTimee = DateTime.parse(entry.dt_txt);
                  return entryDateTimee.hour ==
                      12; // Select only entries at 12 PM
                }).toList();

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      WeatherDetails(
                        tempCelsius: tempCelsius,
                        description: description,
                        imageUrl: imageUrl,
                        formattedDate: formattedDate,
                        tempMinCelsius: tempMinCelsius,
                        tempMaxCelsius: tempMaxCelsius,
                        windSpeed: windSpeed,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: [
                            Text(
                              'Next Times',
                              style: GoogleFonts.amaranth(
                                textStyle: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //next times Container
                      NextTimesContainer(
                          nextTimefilteredList: nextTimefilteredList),

                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: [
                            Text(
                              'Next Days',
                              style: GoogleFonts.amaranth(
                                textStyle: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomContainer(
                        height: height,
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            // scrollDirection: Axis.horizontal,
                            itemCount: filteredListForNextDays.length,
                            itemBuilder: (context, index) {
                              final tempCelsius = filteredListForNextDays[index]
                                  .main
                                  .temp
                                  .toCelsius;

                              DateTime dateTimee = DateTime.parse(
                                  filteredListForNextDays[index].dt_txt);

                              // Format the date as "Sat"
                              String formattedDate =
                                  DateFormat('E').format(dateTimee);

                              String iconCode = filteredListForNextDays[index]
                                  .weather[0]
                                  .icon;
                              final imageUrl = getWeatherIcons(iconCode);

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      formattedDate,
                                      style: GoogleFonts.amaranth(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
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
                                      '${tempCelsius.round()}°',
                                      style: GoogleFonts.amaranth(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text(
                    error.toString().contains('City not found')
                        ? 'City not found. Please try again.'
                        : 'An error occurred. Please try again.',
                    style: GoogleFonts.amaranth(
                      textStyle: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              },
              loading: () {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrange,
                  ),
                );
              },
            );
          },
        ));
  }

  AppBar _appBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Color(0xF5F5F5F5),
      title: Row(
        children: [
          Image.asset(
            'assets/icons/appbar/location.png',
            scale: 14,
          ),
          SizedBox(
            width: 5,
          ),
          Consumer(
            builder: (context, ref, child) {
              if (_currentPosition == null) {
                return SizedBox();
              } else {
                final weather =
                    ref.watch(locationWeatherProvider(_currentPosition!));
                return weather.when(
                  data: (data) {
                    return Text(
                      data.city.name,
                      style: GoogleFonts.amaranth(
                        textStyle: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 23,
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) => Text(
                    error.toString().contains('City not found')
                        ? 'City not found. Please try again.'
                        : 'An error occurred. Please try again.',
                    style: TextStyle(color: Colors.orange),
                  ),
                  loading: () {
                    return SizedBox();
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


}
