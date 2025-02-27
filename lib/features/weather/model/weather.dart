import 'dart:convert';

class WeatherModel {
  String cod;
  int message;
  int cnt;
  List<ListElement> list;
  City city;
  WeatherModel({
    required this.cod,
    required this.message,
    required this.cnt,
    required this.list,
    required this.city,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cod': cod,
      'message': message,
      'cnt': cnt,
      // 'list': list,
      'list': list.map((x) => x.toMap()).toList(),
      'city': city.toMap(),
    };
  }

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      cod: map['cod'] as String,
      message: map['message'] as int,
      cnt: map['cnt'] as int,
      // list: map['list'] as List<ListElement>,
      list: List<ListElement>.from(
          map['list'].map((x) => ListElement.fromMap(x))),
      city: City.fromMap(map['city'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory WeatherModel.fromJson(String source) =>
      WeatherModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ListElement {
  Main main;
  List<Weather> weather;
  String dt_txt;
  Wind wind;

  ListElement({
    required this.main,
    required this.weather,
    required this.dt_txt,
    required this.wind,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'main': main.toMap(),
      'weather': weather.map((x) => x.toMap()).toList(),
      'dt_txt': dt_txt,
      'wind': wind.toMap(),
    };
  }

  factory ListElement.fromMap(Map<String, dynamic> map) {
    return ListElement(
      main: Main.fromMap(map['main'] as Map<String, dynamic>),
      weather:
          List<Weather>.from(map['weather'].map((x) => Weather.fromMap(x))),
      dt_txt: map['dt_txt'] as String,
      wind: Wind.fromMap(map['wind'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListElement.fromJson(String source) =>
      ListElement.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Main {
  double temp;
  double temp_min;
  double temp_max;
  Main({
    required this.temp,
    required this.temp_min,
    required this.temp_max,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'temp': temp,
      'temp_min': temp_min,
      'temp_max': temp_max,
    };
  }

  factory Main.fromMap(Map<String, dynamic> map) {
    return Main(
      // Check if the value is an int, then cast it to double.
      temp: (map['temp'] is int)
          ? (map['temp'] as int).toDouble()
          : map['temp'] as double,
      temp_min: (map['temp_min'] is int)
          ? (map['temp_min'] as int).toDouble()
          : map['temp_min'] as double,
      temp_max: (map['temp_max'] is int)
          ? (map['temp_max'] as int).toDouble()
          : map['temp_max'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Main.fromJson(String source) =>
      Main.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Weather {
  String icon;
  String description;
  Weather({
    required this.icon,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'icon': icon,
      'description': description,
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      icon: map['icon'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Weather.fromJson(String source) =>
      Weather.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Wind {
  double speed;
  Wind({
    required this.speed,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'speed': speed,
    };
  }

  factory Wind.fromMap(Map<String, dynamic> map) {
    return Wind(
      // Check if the value is an int, then cast it to double.
      speed: (map['speed'] is int)
          ? (map['speed'] as int).toDouble()
          : map['speed'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Wind.fromJson(String source) =>
      Wind.fromMap(json.decode(source) as Map<String, dynamic>);
}

class City {
  int id;
  String name;
  City({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory City.fromJson(String source) =>
      City.fromMap(json.decode(source) as Map<String, dynamic>);
}
