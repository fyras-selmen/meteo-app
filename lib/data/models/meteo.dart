import 'dart:convert';

Meteo meteoFromJson(String str) => Meteo.fromJson(json.decode(str));

String meteoToJson(Meteo data) => json.encode(data.toJson());
List<Meteo> cityListFromJson(List<dynamic> jsonList) =>
    jsonList.map((json) => Meteo.fromJson(json)).toList();

class Meteo {
  String? city;
  double latitude;
  double longitude;
  double generationtimeMs;
  int utcOffsetSeconds;
  String timezone;
  String timezoneAbbreviation;
  double elevation;
  CurrentUnits currentUnits;
  Current current;
  HourlyUnits hourlyUnits;
  Hourly hourly;

  Meteo(
      {this.city,
      required this.latitude,
      required this.longitude,
      required this.generationtimeMs,
      required this.utcOffsetSeconds,
      required this.timezone,
      required this.timezoneAbbreviation,
      required this.elevation,
      required this.currentUnits,
      required this.current,
      required this.hourlyUnits,
      required this.hourly});

  factory Meteo.fromJson(Map<String, dynamic> json) => Meteo(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        generationtimeMs: json["generationtime_ms"]?.toDouble(),
        utcOffsetSeconds: json["utc_offset_seconds"],
        timezone: json["timezone"],
        city: json["city"],
        timezoneAbbreviation: json["timezone_abbreviation"],
        elevation: json["elevation"],
        currentUnits: CurrentUnits.fromJson(json["current_units"]),
        current: Current.fromJson(json["current"]),
        hourlyUnits: HourlyUnits.fromJson(json["hourly_units"]),
        hourly: Hourly.fromJson(json["hourly"]),
      );

  Map<String, dynamic> toJson() => {
        "city": city ?? "",
        "latitude": latitude,
        "longitude": longitude,
        "generationtime_ms": generationtimeMs,
        "utc_offset_seconds": utcOffsetSeconds,
        "timezone": timezone,
        "timezone_abbreviation": timezoneAbbreviation,
        "elevation": elevation,
        "current_units": currentUnits.toJson(),
        "current": current.toJson(),
        "hourly_units": hourlyUnits.toJson(),
        "hourly": hourly.toJson(),
      };
}

class Current {
  String time;
  int interval;
  double temperature;
  int humidity;
  int weatherCode;
  double windSpeed;
  int windDirection;

  Current({
    required this.time,
    required this.interval,
    required this.temperature,
    required this.humidity,
    required this.weatherCode,
    required this.windSpeed,
    required this.windDirection,
  });

  factory Current.fromJson(Map<String, dynamic> json) => Current(
        time: json["time"],
        interval: json["interval"],
        temperature: json["temperature_2m"]?.toDouble(),
        humidity: json["relative_humidity_2m"],
        weatherCode: json["weather_code"],
        windSpeed: json["wind_speed_10m"]?.toDouble(),
        windDirection: json["wind_direction_10m"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "interval": interval,
        "temperature_2m": temperature,
        "relative_humidity_2m": humidity,
        "weather_code": weatherCode,
        "wind_speed_10m": windSpeed,
        "wind_direction_10m": windDirection,
      };
}

class CurrentUnits {
  String time;
  String interval;
  String temperature;
  String humidity;
  String weatherCode;
  String windSpeed;
  String windDirection;

  CurrentUnits({
    required this.time,
    required this.interval,
    required this.temperature,
    required this.humidity,
    required this.weatherCode,
    required this.windSpeed,
    required this.windDirection,
  });

  factory CurrentUnits.fromJson(Map<String, dynamic> json) => CurrentUnits(
        time: json["time"],
        interval: json["interval"],
        temperature: json["temperature_2m"],
        humidity: json["relative_humidity_2m"],
        weatherCode: json["weather_code"],
        windSpeed: json["wind_speed_10m"],
        windDirection: json["wind_direction_10m"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "interval": interval,
        "temperature_2m": temperature,
        "relative_humidity_2m": humidity,
        "weather_code": weatherCode,
        "wind_speed_10m": windSpeed,
        "wind_direction_10m": windDirection,
      };
}

class Hourly {
  List<String> time;
  List<double> temperature;

  Hourly({
    required this.time,
    required this.temperature,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
        time: List<String>.from(json["time"].map((x) => x)),
        temperature:
            List<double>.from(json["temperature_2m"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "time": List<dynamic>.from(time.map((x) => x)),
        "temperature_2m": List<dynamic>.from(temperature.map((x) => x)),
      };
}

class HourlyUnits {
  String time;
  String temperature;

  HourlyUnits({
    required this.time,
    required this.temperature,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) => HourlyUnits(
        time: json["time"],
        temperature: json["temperature_2m"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "temperature_2m": temperature,
      };
}
