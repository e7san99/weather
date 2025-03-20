import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const _cityNameStatus = "cityNameStatus";
  setCityName(String cityName) async {
    SharedPreferences prefsCityName = await SharedPreferences.getInstance();
    return prefsCityName.setString(_cityNameStatus, cityName);
  }

  Future<String> getCityName() async {
    SharedPreferences prefsCityName = await SharedPreferences.getInstance();
    return prefsCityName.getString(_cityNameStatus) ?? '';
  }

  //   Future<void> clearCityName() async {
  //   SharedPreferences prefsCityName = await SharedPreferences.getInstance();
  //   await prefsCityName.remove(_cityNameStatus);
  // }

}
