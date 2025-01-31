import 'dart:convert';

class SingleOrderModel {
  String cod;
  int message;
  int cnt;
  List<ListElement> list;
  City city;
  SingleOrderModel({
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

  factory SingleOrderModel.fromMap(Map<String, dynamic> map) {
    return SingleOrderModel(
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

  factory SingleOrderModel.fromJson(String source) =>
      SingleOrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ListElement {
  Main main;

  ListElement({
    required this.main,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'main': main.toMap(),
    };
  }

  factory ListElement.fromMap(Map<String, dynamic> map) {
    return ListElement(
      main: Main.fromMap(map['main'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListElement.fromJson(String source) =>
      ListElement.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Main {
  double temp;
  Main({
    required this.temp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'temp': temp,
    };
  }

  factory Main.fromMap(Map<String, dynamic> map) {
   return Main(
      // Check if the value is an int, then cast it to double.
      temp: (map['temp'] is int) ? (map['temp'] as int).toDouble() : map['temp'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Main.fromJson(String source) =>
      Main.fromMap(json.decode(source) as Map<String, dynamic>);
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


// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// import 'package:flutter/foundation.dart';

// class SingleOrderModel {
//   String cod;
//   int message;
//   int cnt;
//   List<ListElement> list;
//   City city;
//   SingleOrderModel({
//     required this.cod,
//     required this.message,
//     required this.cnt,
//     required this.list,
//     required this.city,
//   });

//   SingleOrderModel copyWith({
//     String? cod,
//     int? message,
//     int? cnt,
//     List<ListElement>? list,
//     City? city,
//   }) {
//     return SingleOrderModel(
//       cod: cod ?? this.cod,
//       message: message ?? this.message,
//       cnt: cnt ?? this.cnt,
//       list: list ?? this.list,
//       city: city ?? this.city,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'cod': cod,
//       'message': message,
//       'cnt': cnt,
//       'list': list,
//       'city': city.toMap(),
//     };
//   }

//   factory SingleOrderModel.fromMap(Map<String, dynamic> map) {
//     return SingleOrderModel(
//       cod: map['cod'] as String,
//       message: map['message'] as int,
//       cnt: map['cnt'] as int,
//       list: map['list'] as List<ListElement>,
//       city: City.fromMap(map['city'] as Map<String,dynamic>),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory SingleOrderModel.fromJson(String source) => SingleOrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'SingleOrderModel(cod: $cod, message: $message, cnt: $cnt, list: $list, city: $city)';
//   }

//   @override
//   bool operator ==(covariant SingleOrderModel other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.cod == cod &&
//       other.message == message &&
//       other.cnt == cnt &&
//       listEquals(other.list, list) &&
//       other.city == city;
//   }

//   @override
//   int get hashCode {
//     return cod.hashCode ^
//       message.hashCode ^
//       cnt.hashCode ^
//       list.hashCode ^
//       city.hashCode;
//   }
// }

// class City {
//   int id;
//   String name;
//   Coord coord;
//   String country;
//   int population;
//   int timezone;
//   int sunrise;
//   int sunset;
//   City({
//     required this.id,
//     required this.name,
//     required this.coord,
//     required this.country,
//     required this.population,
//     required this.timezone,
//     required this.sunrise,
//     required this.sunset,
//   });

//   City copyWith({
//     int? id,
//     String? name,
//     Coord? coord,
//     String? country,
//     int? population,
//     int? timezone,
//     int? sunrise,
//     int? sunset,
//   }) {
//     return City(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       coord: coord ?? this.coord,
//       country: country ?? this.country,
//       population: population ?? this.population,
//       timezone: timezone ?? this.timezone,
//       sunrise: sunrise ?? this.sunrise,
//       sunset: sunset ?? this.sunset,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'name': name,
//       'coord': coord.toMap(),
//       'country': country,
//       'population': population,
//       'timezone': timezone,
//       'sunrise': sunrise,
//       'sunset': sunset,
//     };
//   }

//   factory City.fromMap(Map<String, dynamic> map) {
//     return City(
//       id: map['id'] as int,
//       name: map['name'] as String,
//       coord: Coord.fromMap(map['coord'] as Map<String,dynamic>),
//       country: map['country'] as String,
//       population: map['population'] as int,
//       timezone: map['timezone'] as int,
//       sunrise: map['sunrise'] as int,
//       sunset: map['sunset'] as int,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory City.fromJson(String source) => City.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'City(id: $id, name: $name, coord: $coord, country: $country, population: $population, timezone: $timezone, sunrise: $sunrise, sunset: $sunset)';
//   }

//   @override
//   bool operator ==(covariant City other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.id == id &&
//       other.name == name &&
//       other.coord == coord &&
//       other.country == country &&
//       other.population == population &&
//       other.timezone == timezone &&
//       other.sunrise == sunrise &&
//       other.sunset == sunset;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//       name.hashCode ^
//       coord.hashCode ^
//       country.hashCode ^
//       population.hashCode ^
//       timezone.hashCode ^
//       sunrise.hashCode ^
//       sunset.hashCode;
//   }
// }

// class Coord {
//   double lat;
//   double lon;
//   Coord({
//     required this.lat,
//     required this.lon,
//   });

//   Coord copyWith({
//     double? lat,
//     double? lon,
//   }) {
//     return Coord(
//       lat: lat ?? this.lat,
//       lon: lon ?? this.lon,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'lat': lat,
//       'lon': lon,
//     };
//   }

//   factory Coord.fromMap(Map<String, dynamic> map) {
//     return Coord(
//       lat: map['lat'] as double,
//       lon: map['lon'] as double,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Coord.fromJson(String source) => Coord.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() => 'Coord(lat: $lat, lon: $lon)';

//   @override
//   bool operator ==(covariant Coord other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.lat == lat &&
//       other.lon == lon;
//   }

//   @override
//   int get hashCode => lat.hashCode ^ lon.hashCode;
// }

// class ListElement {
//   int dt;
//   MainClass main;
//   List<Weather> weather;
//   Clouds clouds;
//   Wind wind;
//   int visibility;
//   double pop;
//   Sys sys;
//   DateTime dtTxt;
//   Rain? rain;

//   ListElement({
//     required this.dt,
//     required this.main,
//     required this.weather,
//     required this.clouds,
//     required this.wind,
//     required this.visibility,
//     required this.pop,
//     required this.sys,
//     required this.dtTxt,
//     this.rain,
//   });

//   ListElement copyWith({
//     int? dt,
//     MainClass? main,
//     List<Weather>? weather,
//     Clouds? clouds,
//     Wind? wind,
//     int? visibility,
//     double? pop,
//     Sys? sys,
//     DateTime? dtTxt,
//     Rain? rain,
//   }) =>
//       ListElement(
//         dt: dt ?? this.dt,
//         main: main ?? this.main,
//         weather: weather ?? this.weather,
//         clouds: clouds ?? this.clouds,
//         wind: wind ?? this.wind,
//         visibility: visibility ?? this.visibility,
//         pop: pop ?? this.pop,
//         sys: sys ?? this.sys,
//         dtTxt: dtTxt ?? this.dtTxt,
//         rain: rain ?? this.rain,
//       );
// }

// class Clouds {
//   int all;
//   Clouds({
//     required this.all,
//   });


//   Clouds copyWith({
//     int? all,
//   }) {
//     return Clouds(
//       all: all ?? this.all,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'all': all,
//     };
//   }

//   factory Clouds.fromMap(Map<String, dynamic> map) {
//     return Clouds(
//       all: map['all'] as int,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Clouds.fromJson(String source) => Clouds.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() => 'Clouds(all: $all)';

//   @override
//   bool operator ==(covariant Clouds other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.all == all;
//   }

//   @override
//   int get hashCode => all.hashCode;
// }

// class MainClass {
//   double temp;
//   double feelsLike;
//   double tempMin;
//   double tempMax;
//   int pressure;
//   int seaLevel;
//   int grndLevel;
//   int humidity;
//   double tempKf;
//   MainClass({
//     required this.temp,
//     required this.feelsLike,
//     required this.tempMin,
//     required this.tempMax,
//     required this.pressure,
//     required this.seaLevel,
//     required this.grndLevel,
//     required this.humidity,
//     required this.tempKf,
//   });

  

//   MainClass copyWith({
//     double? temp,
//     double? feelsLike,
//     double? tempMin,
//     double? tempMax,
//     int? pressure,
//     int? seaLevel,
//     int? grndLevel,
//     int? humidity,
//     double? tempKf,
//   }) {
//     return MainClass(
//       temp: temp ?? this.temp,
//       feelsLike: feelsLike ?? this.feelsLike,
//       tempMin: tempMin ?? this.tempMin,
//       tempMax: tempMax ?? this.tempMax,
//       pressure: pressure ?? this.pressure,
//       seaLevel: seaLevel ?? this.seaLevel,
//       grndLevel: grndLevel ?? this.grndLevel,
//       humidity: humidity ?? this.humidity,
//       tempKf: tempKf ?? this.tempKf,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'temp': temp,
//       'feelsLike': feelsLike,
//       'tempMin': tempMin,
//       'tempMax': tempMax,
//       'pressure': pressure,
//       'seaLevel': seaLevel,
//       'grndLevel': grndLevel,
//       'humidity': humidity,
//       'tempKf': tempKf,
//     };
//   }

//   factory MainClass.fromMap(Map<String, dynamic> map) {
//     return MainClass(
//       temp: map['temp'] as double,
//       feelsLike: map['feelsLike'] as double,
//       tempMin: map['tempMin'] as double,
//       tempMax: map['tempMax'] as double,
//       pressure: map['pressure'] as int,
//       seaLevel: map['seaLevel'] as int,
//       grndLevel: map['grndLevel'] as int,
//       humidity: map['humidity'] as int,
//       tempKf: map['tempKf'] as double,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory MainClass.fromJson(String source) => MainClass.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'MainClass(temp: $temp, feelsLike: $feelsLike, tempMin: $tempMin, tempMax: $tempMax, pressure: $pressure, seaLevel: $seaLevel, grndLevel: $grndLevel, humidity: $humidity, tempKf: $tempKf)';
//   }

//   @override
//   bool operator ==(covariant MainClass other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.temp == temp &&
//       other.feelsLike == feelsLike &&
//       other.tempMin == tempMin &&
//       other.tempMax == tempMax &&
//       other.pressure == pressure &&
//       other.seaLevel == seaLevel &&
//       other.grndLevel == grndLevel &&
//       other.humidity == humidity &&
//       other.tempKf == tempKf;
//   }

//   @override
//   int get hashCode {
//     return temp.hashCode ^
//       feelsLike.hashCode ^
//       tempMin.hashCode ^
//       tempMax.hashCode ^
//       pressure.hashCode ^
//       seaLevel.hashCode ^
//       grndLevel.hashCode ^
//       humidity.hashCode ^
//       tempKf.hashCode;
//   }
// }

// class Rain {
//   double the3H;
//   Rain({
//     required this.the3H,
//   });


//   Rain copyWith({
//     double? the3H,
//   }) {
//     return Rain(
//       the3H: the3H ?? this.the3H,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'the3H': the3H,
//     };
//   }

//   factory Rain.fromMap(Map<String, dynamic> map) {
//     return Rain(
//       the3H: map['the3H'] as double,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Rain.fromJson(String source) => Rain.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() => 'Rain(the3H: $the3H)';

//   @override
//   bool operator ==(covariant Rain other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.the3H == the3H;
//   }

//   @override
//   int get hashCode => the3H.hashCode;
// }

// class Sys {
//   Pod pod;

//   Sys({
//     required this.pod,
//   });

//   Sys copyWith({
//     Pod? pod,
//   }) {
//     return Sys(
//       pod: pod ?? this.pod,
//     );
//   }

//   Map<String, dynamic> toMap() {  
//     return <String, dynamic>{
//       'pod': pod,
//     };
//   }

//   factory Sys.fromMap(Map<String, dynamic> map) {  
//     return Sys(
//       pod: map['pod'] as Pod,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Sys.fromJson(String source) => Sys.fromMap(json.decode(source) as Map<String, dynamic>);

// }

// enum Pod { D, N }

// class Weather {
//   int id;
//   MainEnum main;
//   String description;
//   String icon;
//   Weather({
//     required this.id,
//     required this.main,
//     required this.description,
//     required this.icon,
//   });



//   Weather copyWith({
//     int? id,
//     MainEnum? main,
//     String? description,
//     String? icon,
//   }) {
//     return Weather(
//       id: id ?? this.id,
//       main: main ?? this.main,
//       description: description ?? this.description,
//       icon: icon ?? this.icon,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'main': main,
//       'description': description,
//       'icon': icon,
//     };
//   }

//   factory Weather.fromMap(Map<String, dynamic> map) {
//     return Weather(
//       id: map['id'] as int,
//       main: map['main'] as MainEnum,
//       description: map['description'] as String,
//       icon: map['icon'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Weather.fromJson(String source) => Weather.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'Weather(id: $id, main: $main, description: $description, icon: $icon)';
//   }

//   @override
//   bool operator ==(covariant Weather other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.id == id &&
//       other.main == main &&
//       other.description == description &&
//       other.icon == icon;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//       main.hashCode ^
//       description.hashCode ^
//       icon.hashCode;
//   }
// }

// enum MainEnum { clear, clouds, rain }

// class Wind {
//   double speed;
//   int deg;
//   double gust;
//   Wind({
//     required this.speed,
//     required this.deg,
//     required this.gust,
//   });

 

//   Wind copyWith({
//     double? speed,
//     int? deg,
//     double? gust,
//   }) {
//     return Wind(
//       speed: speed ?? this.speed,
//       deg: deg ?? this.deg,
//       gust: gust ?? this.gust,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'speed': speed,
//       'deg': deg,
//       'gust': gust,
//     };
//   }

//   factory Wind.fromMap(Map<String, dynamic> map) {
//     return Wind(
//       speed: map['speed'] as double,
//       deg: map['deg'] as int,
//       gust: map['gust'] as double,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Wind.fromJson(String source) => Wind.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() => 'Wind(speed: $speed, deg: $deg, gust: $gust)';

//   @override
//   bool operator ==(covariant Wind other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.speed == speed &&
//       other.deg == deg &&
//       other.gust == gust;
//   }

//   @override
//   int get hashCode => speed.hashCode ^ deg.hashCode ^ gust.hashCode;
// }
