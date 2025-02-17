import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_pod/features/weather/data/riverpod/fetch_weather_by_city.dart';
import 'package:weather_pod/features/weather/presentation/widgets/container.dart';
import 'package:weather_pod/features/weather/utils/extention.dart';

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
        appBar: AppBar(
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
        ),
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

                String iconCode = data.list[0].weather[0].icon;
                String imageUrl = _weatherIcons(iconCode);

                final double width = MediaQuery.sizeOf(context).width;
                final double height = MediaQuery.sizeOf(context).height;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomContainer(
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
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white,
                                      Colors.grey,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomLeft,
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  description,
                                  style: GoogleFonts.amaranth(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //date
                            Positioned(
                              top: height * 0.22,
                              left: width * 0.07,
                              child: Text(
                                formattedDate,
                                style: GoogleFonts.amaranth(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            //Base Temperature
                            Positioned(
                              top: height * 0.013,
                              right: width * 0.14,
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white,
                                      Colors.grey,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomLeft,
                                  ).createShader(bounds);
                                },
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: tempCelsius.toStringAsFixed(0),
                                        style: GoogleFonts.amaranth(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 72,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'C',
                                        style: GoogleFonts.amaranth(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                60, // Smaller font size for 'C°'
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //temp dgree °
                            Positioned(
                              top: height * 0.02,
                              right: width * 0.14,
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white,
                                      Colors.grey,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomLeft,
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  '°',
                                  style: GoogleFonts.amaranth(
                                    textStyle: TextStyle(
                                      color: Colors
                                          .white, // This color is required but will be overridden by the gradient
                                      fontSize: 47,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //min max temp
                            Positioned(
                              top: height * 0.17,
                              right: width * 0.16,
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/down-arrow.png',
                                    scale: 18,
                                    color: const Color(0xE7F1E9E9),
                                  ),
                                  Text(
                                    '${tempMinCelsius.toStringAsFixed(0)}° / ${tempMaxCelsius.toStringAsFixed(0)}°',
                                    style: GoogleFonts.amaranth(
                                      textStyle: TextStyle(
                                        color: Color(0xE7F1E9E9),
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
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
                                'Wind speed: ${data.list[0].wind.speed} m/s',
                                style: GoogleFonts.amaranth(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            //vertical line
                            Positioned(
                              top: height * 0.21,
                              left: width * 0.42,
                              child: Container(
                                height: 30, // Adjust the height as needed
                                width:
                                    2, // Adjust the width of the vertical line
                                color: Color(0xE7F1E9E9),
                              ),
                            ),
                          ],
                        ),
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
                      //second Container
                      Container(
                        height: 200,
                        margin: EdgeInsets.all(8),
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            end: Alignment.topLeft,
                            tileMode: TileMode.mirror,
                            colors: [
                              Colors.orange,
                              Colors.deepOrange,
                              Colors.deepOrangeAccent,
                            ],
                          ),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: weather.when(
                                data: (data) {
                                  DateTime now = DateTime.now();
                                  DateTime today =
                                      DateTime(now.year, now.month, now.day);
                                  DateTime tomorrow =
                                      today.add(Duration(days: 1));

                                  // Filter data to include only today and tomorrow
                                  final filteredList = data.list.where((entry) {
                                    DateTime entryDate =
                                        DateTime.parse(entry.dt_txt);
                                    return entryDate.isAfter(today
                                            .subtract(Duration(seconds: 1))) &&
                                        entryDate.isBefore(
                                            tomorrow.add(Duration(days: 1)));
                                  }).toList();

                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final tempCelsiuss =
                                          data.list[index].main.temp - 273.15;

                                      DateTime dateTimee = DateTime.parse(
                                          filteredList[index].dt_txt);

                                      String formattedDate =
                                          DateFormat.jm().format(dateTimee);

                                      String iconCodee =
                                          data.list[index].weather[0].icon;
                                      String imageUrll;
                                      switch (iconCodee) {
                                        //days
                                        case '01d':
                                          imageUrll = 'assets/icons/01d.png';
                                          break;
                                        case '02d':
                                          imageUrll = 'assets/icons/02d.png';
                                          break;
                                        case '03d':
                                          imageUrll = 'assets/icons/03d.png';
                                          break;
                                        case '04d':
                                          imageUrll = 'assets/icons/04d.png';
                                          break;
                                        case '09d':
                                          imageUrll = 'assets/icons/09d.png';
                                          break;
                                        case '10d':
                                          imageUrll = 'assets/icons/10d.png';
                                          break;
                                        case '11d':
                                          imageUrll = 'assets/icons/11d.png';
                                          break;
                                        case '13d':
                                          imageUrll = 'assets/icons/13d.png';
                                          break;
                                        case '50d':
                                          imageUrll = 'assets/icons/50d.png';
                                          break;
                                        default:
                                          // imageUrl = 'assets/icons/moon.png';
                                          imageUrll = 'assets/icons/03d.png';
                                          break;
                                      }

                                      return Column(
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
                                            imageUrll,
                                            height: 60,
                                            fit: BoxFit.fill,
                                            // color: whiteColor,
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '${tempCelsiuss.round()}°',
                                                  style: GoogleFonts.amaranth(
                                                    textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                error: (error, stackTrace) => Text(
                                      error
                                              .toString()
                                              .contains('City not found')
                                          ? 'City not found. Please try again.'
                                          : 'An error occurred. Please try again.',
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                loading: () => Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.blue,
                                      ),
                                    ))),
                      ),
                      SizedBox(
                        height: 20,
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
                      Container(
                        height: 200,
                        margin: EdgeInsets.all(8),
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            tileMode: TileMode.mirror,
                            colors: [
                              Colors.orange,
                              Colors.deepOrange,
                              Colors.deepOrangeAccent,
                            ],
                          ),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: weather.when(
                                data: (data) {
                                  // Filter data to include only today and tomorrow
                                  // Filter data to show only 12:00 PM (noon) entries
                                  final filteredList = data.list.where((entry) {
                                    DateTime entryDateTime =
                                        DateTime.parse(entry.dt_txt);
                                    return entryDateTime.hour ==
                                        12; // Select only entries at 12 PM
                                  }).toList();

                                  return ListView.builder(
                                    // scrollDirection: Axis.horizontal,
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final tempCelsius =
                                          filteredList[index].main.temp -
                                              273.15;
                                      DateTime dateTime = DateTime.parse(
                                          filteredList[index].dt_txt);

                                      // Format the date as "Sat 2/15/2025 12:00 PM"
                                      String formattedDate =
                                          DateFormat('E').format(dateTime);

                                      String iconCodee =
                                          filteredList[index].weather[0].icon;
                                      String imageUrlll;
                                      switch (iconCodee) {
                                        //days
                                        case '01d':
                                          imageUrlll = 'assets/icons/01d.png';
                                          break;
                                        case '02d':
                                          imageUrlll = 'assets/icons/02d.png';
                                          break;
                                        case '03d':
                                          imageUrlll = 'assets/icons/03d.png';
                                          break;
                                        case '04d':
                                          imageUrlll = 'assets/icons/04d.png';
                                          break;
                                        case '09d':
                                          imageUrlll = 'assets/icons/09d.png';
                                          break;
                                        case '10d':
                                          imageUrlll = 'assets/icons/10d.png';
                                          break;
                                        case '11d':
                                          imageUrlll = 'assets/icons/11d.png';
                                          break;
                                        case '13d':
                                          imageUrlll = 'assets/icons/13d.png';
                                          break;
                                        case '50d':
                                          imageUrlll = 'assets/icons/50d.png';
                                          break;
                                        default:
                                          // imageUrl = 'assets/icons/moon.png';
                                          imageUrlll = 'assets/icons/03d.png';
                                          break;
                                      }

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
                                            imageUrlll,
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
                                  );
                                },
                                error: (error, stackTrace) => Text(
                                      error
                                              .toString()
                                              .contains('City not found')
                                          ? 'City not found. Please try again.'
                                          : 'An error occurred. Please try again.',
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                loading: () => Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.blue,
                                      ),
                                    ))),
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

  String _weatherIcons(String iconCode) {
    String imageUrl;
    switch (iconCode) {
      //days
      case '01d':
        imageUrl = 'assets/icons/01d.png';
        break;
      case '02d':
        imageUrl = 'assets/icons/02d.png';
        break;
      case '03d':
        imageUrl = 'assets/icons/03d.png';
        break;
      case '04d':
        imageUrl = 'assets/icons/04d.png';
        break;
      case '09d':
        imageUrl = 'assets/icons/09d.png';
        break;
      case '10d':
        imageUrl = 'assets/icons/10d.png';
        break;
      case '11d':
        imageUrl = 'assets/icons/11d.png';
        break;
      case '13d':
        imageUrl = 'assets/icons/13d.png';
        break;
      case '50d':
        imageUrl = 'assets/icons/50d.png';
        break;
      default:
        imageUrl = 'assets/icons/03d.png';
        break;
    }
    return imageUrl;
  }
}
