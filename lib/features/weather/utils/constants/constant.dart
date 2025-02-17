  String getWeatherIcons(String iconCode) {
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


List getFilteredList(List dataList) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime tomorrow = today.add(Duration(days: 1));

  return dataList.where((entry) {
    DateTime entryDate = DateTime.parse(entry.dt_txt);
    return entryDate.isAfter(today) && entryDate.isBefore(tomorrow);
  }).toList();
}

List getFilteredListForNextDays(List dataList) {
  return dataList.where((entry) {
    DateTime entryDate = DateTime.parse(entry.dt_txt);
    return entryDate.hour == 12;
  }).toList();
}
