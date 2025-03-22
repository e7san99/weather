import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/features/weather/data/riverpod/riverpod.dart';
import 'package:weather/utils/utils.dart';

class AppbarHomePage extends StatefulWidget implements PreferredSizeWidget {
  final Position? currentPosition;
  final TextEditingController searchController;
  const AppbarHomePage({
    super.key,
    required this.currentPosition,
    required this.searchController,
  });

  @override
  State<AppbarHomePage> createState() => _AppbarHomePageState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppbarHomePageState extends State<AppbarHomePage> {
  TextStyle cityNameStyle = textStyle(blueColor, 23);

  void _changeLanguage(BuildContext context, String languageCode) {
    context.setLocale(Locale(languageCode));
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
              PopupMenuButton<String>(
                child: Tooltip(
         message: 'change_language'.tr(), 
        child: Row(
                  children: [
                    
                    // Spacing
                    Icon(Icons.public, color: blueColor),
                    Icon(Icons.arrow_drop_down_rounded, color: blueColor),
                  ],
                ),
      ),
                
                
                onSelected: (String languageCode) {
                  _changeLanguage(context, languageCode);
                },
                itemBuilder: (BuildContext context) {
                  return {'en', 'ar'}.map((String languageCode) {
                    return PopupMenuItem<String>(
                      value: languageCode,
                      child: Text(languageCode == 'en' ? 'English' : 'Kurdish'),
                    );
                  }).toList();
                },
              ),
              IconButton(
                icon: Image.asset(
                  'assets/icons/appbar/location.png',
                  scale: 14,
                  color: blueColor,
                ),
                onPressed: () {
                  ref.read(useCurrentLocationProvider.notifier).state = true;
                  ref.read(cityProvider.notifier).state = '';
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  final useCurrentLocation = ref.watch(
                    useCurrentLocationProvider,
                  );
                  if (useCurrentLocation) {
                    if (widget.currentPosition == null) {
                      return ShimmeringAppbar();
                    } else {
                      final weather = ref.watch(
                        locationWeatherProvider(widget.currentPosition!),
                      );
                      return weather.when(
                        data: (data) {
                          return Text(data.city.name, style: cityNameStyle);
                        },
                        error: (error, stackTrace) => SizedBox(),
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
                          style: textStyle(blueColor, 23),
                        );
                      },
                      error: (error, stackTrace) => SizedBox(),
                      loading: () {
                        return ShimmeringAppbar();
                      },
                    );
                  }
                },
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            InkWell(
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              onTap: () => _openSearchModal(context, ref),
              child: Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Image.asset('assets/icons/appbar/search.png', scale: 14),
              ),
            ),
          ],
          elevation: 0,
        );
      },
    );
  }

  void _openSearchModal(BuildContext context, WidgetRef ref) {
    // Clear the text field and reset isEmpty state when opening the modal
    widget.searchController.clear();
    ref.read(isTextfieldEmptyProvider.notifier).state = false;

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
                      borderSide: BorderSide(color: blueColor, width: 2),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: blueColor, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: blueColor, width: 2),
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: blueColor),
                    suffixIcon: IconButton(
                      onPressed: () {
                        widget.searchController.clear();
                        ref.read(isTextfieldEmptyProvider.notifier).state =
                            false; // Reset isEmpty state
                      },
                      icon: Icon(Icons.close, color: blueColor),
                    ),
                  ),
                  style: TextStyle(color: blueColor),
                  onSubmitted: (value) {
                    if (value.trim().isEmpty) {
                      ref.read(isTextfieldEmptyProvider.notifier).state =
                          true; // Set isEmpty to true
                    } else {
                      ref.read(cityProvider.notifier).state = value.trim();
                      ref.read(useCurrentLocationProvider.notifier).state =
                          false;
                      Navigator.pop(context);
                    }
                  },
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final isEmpty = ref.watch(isTextfieldEmptyProvider);
                    return isEmpty
                        ? Text(
                          'Please enter a city name',
                          style: textStyle(Colors.red, 14),
                        )
                        : SizedBox();
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(blueColor),
                  ),
                  onPressed: () {
                    if (widget.searchController.text.trim().isEmpty) {
                      ref.read(isTextfieldEmptyProvider.notifier).state =
                          true; // Set isEmpty to true
                    } else {
                      ref.read(cityProvider.notifier).state =
                          widget.searchController.text.trim();
                      ref.read(useCurrentLocationProvider.notifier).state =
                          false;
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Search', style: textStyle(whiteColor, 16)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
