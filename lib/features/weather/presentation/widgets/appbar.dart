import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_pod/features/weather/data/riverpod/fetch_weather.dart';
import 'package:weather_pod/features/weather/utils/shimmers/shimmering_appbar.dart';
import 'package:weather_pod/features/weather/utils/style.dart';

class AppbarHomePage extends StatefulWidget implements PreferredSizeWidget {
  final Position? currentPosition;
  final TextEditingController searchController;
  const AppbarHomePage(
      {super.key,
      required this.currentPosition,
      required this.searchController});

  @override
  State<AppbarHomePage> createState() => _AppbarHomePageState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppbarHomePageState extends State<AppbarHomePage> {
  void _openSearchModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: widget.searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.blue),
                      suffixIcon: IconButton(
                        onPressed: () {
                          widget.searchController.clear();
                        },
                        icon: Icon(Icons.close, color: Colors.blue),
                      )),
                  style: TextStyle(color: Colors.blue),
                  onSubmitted: (value) {
                    ref.read(cityProvider.notifier).state = value;
                    ref.read(useCurrentLocationProvider.notifier).state = false;
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    ref.read(cityProvider.notifier).state =
                        widget.searchController.text;
                    ref.read(useCurrentLocationProvider.notifier).state = false;
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Search',
                    style: textStyle(16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Color(0xF5F5F5F5),
          title: Row(
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/icons/appbar/location.png',
                  scale: 14,
                  color: Colors.blue,
                ),
                onPressed: () {
                  ref.read(useCurrentLocationProvider.notifier).state = true;
                  ref.read(cityProvider.notifier).state = '';
                },
              ),
              SizedBox(
                width: 5,
              ),
              Consumer(
                builder: (context, ref, child) {
                  final useCurrentLocation =
                      ref.watch(useCurrentLocationProvider);
                  if (useCurrentLocation) {
                    if (widget.currentPosition == null) {
                      return SizedBox();
                    } else {
                      final weather = ref.watch(
                          locationWeatherProvider(widget.currentPosition!));
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
                  } else {
                    final city = ref.watch(cityProvider);
                    final weather = ref.watch(weatherProvider(city));
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
                      error: (error, stackTrace) => SizedBox(),
                      //  Text(
                      //   error.toString().contains('City not found')
                      //       ? 'City not found. Please try again.'
                      //       : 'An error occurred. Please try again.',
                      //   style: TextStyle(color: Colors.blue),
                      // ),
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
              onTap: () => _openSearchModal(context, ref),
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
      },
    );
  }
}
