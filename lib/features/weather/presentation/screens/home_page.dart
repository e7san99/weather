import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_pod/features/weather/data/riverpod/fetch_weather_by_city.dart';

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
                    return Text('');
                    // Text(
                    //   'Loading...', // 'Current Location is null',
                    //   style: GoogleFonts.amaranth(
                    //     textStyle: TextStyle(
                    //       color: Colors.deepOrange,
                    //       fontSize: 18,
                    //     ),
                    //   ),
                    // );
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
                        return Text(
                          '',
                        );
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
                double tempCelsius = data.list[0].main.temp - 273.15;
                //date
                DateTime dateTime = DateTime.parse(data.list[0].dt_txt);
                String formattedDate =
                    DateFormat('EEEE, d MMM').format(dateTime);
                //description
                String description = data.list[0].weather[0].description;

                String iconCode = data.list[0].weather[0].icon;
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
                  //nights
                  // case '01n':
                  //   imageUrl = 'assets/icons/01n.png';
                  //   break;
                  // case '02n':
                  //   imageUrl = 'assets/icons/02n.png';
                  //   break;
                  // case '03n':
                  //   imageUrl = 'assets/icons/03n.png';
                  //   break;
                  // case '04n':
                  //   imageUrl = 'assets/icons/04n.png';
                  //   break;
                  // case '09n':
                  //   imageUrl = 'assets/icons/09n.png';
                  //   break;
                  // case '10n':
                  //   imageUrl = 'assets/icons/10n.png';
                  //   break;
                  // case '11n':
                  //   imageUrl = 'assets/icons/11n.png';
                  //   break;
                  // case '13n':
                  //   imageUrl = 'assets/icons/13n.png';
                  //   break;
                  // case '50n':
                  //   imageUrl = 'assets/icons/50n.png';
                  //   break;
                  default:
                    // imageUrl = 'assets/icons/moon.png';
                    imageUrl = 'assets/icons/03d.png';
                    break;
                }

                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
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
                                  ])),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset(
                                    imageUrl,
                                    height: 100,
                                    fit: BoxFit.fill,
                                    // color: whiteColor,
                                  ),
                                  ShaderMask(
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
                                      '${tempCelsius.toStringAsFixed(0)}°',
                                      style: GoogleFonts.amaranth(
                                        textStyle: TextStyle(
                                          color: Colors
                                              .white, // This color is required but will be overridden by the gradient
                                          fontSize: 70,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    description,
                                    style: GoogleFonts.amaranth(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                  //'Monday, 12 Feb'
                                  Text(
                                    formattedDate,
                                    style: GoogleFonts.amaranth(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
                                    final filteredList =
                                        data.list.where((entry) {
                                      DateTime entryDate =
                                          DateTime.parse(entry.dt_txt);
                                      return entryDate.isAfter(today.subtract(
                                              Duration(seconds: 1))) &&
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                      ],
                    ),
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
}
