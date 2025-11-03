// To parse this JSON data, do:
//
//     final weatherModel = weatherModelFromMap(jsonString);

import 'dart:convert';

WeatherModel weatherModelFromMap(String str) =>
    WeatherModel.fromMap(json.decode(str));

String weatherModelToMap(WeatherModel data) => json.encode(data.toMap());

class WeatherModel {
  final Coord coord;
  final List<Weather> weather;
  final String? base;
  final Main main;
  final int? visibility;
  final Wind? wind;
  final Clouds? clouds;
  final int? dt;
  final Sys sys;
  final int? timezone;
  final int? id;
  final String name;
  final int? cod;

  WeatherModel({
    required this.coord,
    required this.weather,
    this.base,
    required this.main,
    this.visibility,
    this.wind,
    this.clouds,
    this.dt,
    required this.sys,
    this.timezone,
    this.id,
    required this.name,
    this.cod,
  });

  factory WeatherModel.fromMap(Map<String, dynamic> json) => WeatherModel(
    coord: Coord.fromMap(json["coord"]),
    weather: List<Weather>.from(
        json["weather"].map((x) => Weather.fromMap(x))),
    base: json["base"],
    main: Main.fromMap(json["main"]),
    visibility: json["visibility"],
    wind:
    json["wind"] != null ? Wind.fromMap(json["wind"]) : null,
    clouds:
    json["clouds"] != null ? Clouds.fromMap(json["clouds"]) : null,
    dt: json["dt"],
    sys: Sys.fromMap(json["sys"]),
    timezone: json["timezone"],
    id: json["id"],
    name: json["name"] ?? "",
    cod: json["cod"],
  );

  Map<String, dynamic> toMap() => {
    "coord": coord.toMap(),
    "weather": List<dynamic>.from(weather.map((x) => x.toMap())),
    "base": base,
    "main": main.toMap(),
    "visibility": visibility,
    "wind": wind?.toMap(),
    "clouds": clouds?.toMap(),
    "dt": dt,
    "sys": sys.toMap(),
    "timezone": timezone,
    "id": id,
    "name": name,
    "cod": cod,
  };
}

class Clouds {
  final int all;

  Clouds({required this.all});

  factory Clouds.fromMap(Map<String, dynamic> json) => Clouds(
    all: json["all"] ?? 0,
  );

  Map<String, dynamic> toMap() => {
    "all": all,
  };
}

class Coord {
  final double lon;
  final double lat;

  Coord({
    required this.lon,
    required this.lat,
  });

  factory Coord.fromMap(Map<String, dynamic> json) => Coord(
    lon: (json["lon"] ?? 0).toDouble(),
    lat: (json["lat"] ?? 0).toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "lon": lon,
    "lat": lat,
  };
}

class Main {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final int? seaLevel;
  final int? grndLevel;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    this.seaLevel,
    this.grndLevel,
  });

  factory Main.fromMap(Map<String, dynamic> json) => Main(
    temp: (json["temp"] ?? 0).toDouble(),
    feelsLike: (json["feels_like"] ?? 0).toDouble(),
    tempMin: (json["temp_min"] ?? 0).toDouble(),
    tempMax: (json["temp_max"] ?? 0).toDouble(),
    pressure: json["pressure"] ?? 0,
    humidity: json["humidity"] ?? 0,
    seaLevel: json["sea_level"],
    grndLevel: json["grnd_level"],
  );

  Map<String, dynamic> toMap() => {
    "temp": temp,
    "feels_like": feelsLike,
    "temp_min": tempMin,
    "temp_max": tempMax,
    "pressure": pressure,
    "humidity": humidity,
    "sea_level": seaLevel,
    "grnd_level": grndLevel,
  };
}

class Sys {
  final int? type;
  final int? id;
  final String country;
  final int sunrise;
  final int sunset;

  Sys({
    this.type,
    this.id,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  factory Sys.fromMap(Map<String, dynamic> json) => Sys(
    type: json["type"],
    id: json["id"],
    country: json["country"] ?? "",
    sunrise: json["sunrise"] ?? 0,
    sunset: json["sunset"] ?? 0,
  );

  Map<String, dynamic> toMap() => {
    "type": type,
    "id": id,
    "country": country,
    "sunrise": sunrise,
    "sunset": sunset,
  };
}

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromMap(Map<String, dynamic> json) => Weather(
    id: json["id"] ?? 0,
    main: json["main"] ?? "",
    description: json["description"] ?? "",
    icon: json["icon"] ?? "",
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "main": main,
    "description": description,
    "icon": icon,
  };
}

class Wind {
  final double speed;
  final int? deg;
  final double? gust;

  Wind({
    required this.speed,
    this.deg,
    this.gust,
  });

  factory Wind.fromMap(Map<String, dynamic> json) => Wind(
    speed: (json["speed"] ?? 0).toDouble(),
    deg: json["deg"],
    gust: json["gust"] != null ? (json["gust"]).toDouble() : null,
  );

  Map<String, dynamic> toMap() => {
    "speed": speed,
    "deg": deg,
    "gust": gust,
  };
}
