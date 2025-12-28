// Model untuk respons cuaca saat ini
class WeatherResponseModel {
  final Location location;
  final Current current;

  WeatherResponseModel({required this.location, required this.current});

  factory WeatherResponseModel.fromJson(Map<String, dynamic> json) {
    return WeatherResponseModel(
      location: Location.fromJson(json['location']),
      current: Current.fromJson(json['current']),
    );
  }
}

// Model untuk respons forecast
class ForecastResponseModel {
  final Location location;
  final Current current;
  final Forecast forecast;

  ForecastResponseModel({required this.location, required this.current, required this.forecast});

  factory ForecastResponseModel.fromJson(Map<String, dynamic> json) {
    return ForecastResponseModel(
      location: Location.fromJson(json['location']),
      current: Current.fromJson(json['current']),
      forecast: Forecast.fromJson(json['forecast']),
    );
  }
}

// --- Kelas-kelas Pembantu ---

class Location {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String tzId;
  final String localtime;

  Location({required this.name, required this.region, required this.country, required this.lat, required this.lon, required this.tzId, required this.localtime});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] ?? '', region: json['region'] ?? '', country: json['country'] ?? '',
      lat: (json['lat'] ?? 0.0).toDouble(), lon: (json['lon'] ?? 0.0).toDouble(),
      tzId: json['tz_id'] ?? '', localtime: json['localtime'] ?? '',
    );
  }
}

class Current {
  final double tempC;
  final double tempF;
  final Condition condition;
  final double windMph;
  final double windKph;
  final int windDegree;
  final String windDir;
  final double pressureMb;
  final double precipMm;
  final int humidity;
  final int cloud;
  final double feelsLikeC;
  final double visKm;
  final double uv;
  final AirQuality? airQuality;

  Current({required this.tempC, required this.tempF, required this.condition, required this.windMph, required this.windKph, required this.windDegree, required this.windDir, required this.pressureMb, required this.precipMm, required this.humidity, required this.cloud, required this.feelsLikeC, required this.visKm, required this.uv, this.airQuality});

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      tempC: (json['temp_c'] ?? 0.0).toDouble(), tempF: (json['temp_f'] ?? 0.0).toDouble(),
      condition: Condition.fromJson(json['condition'] ?? {}),
      windMph: (json['wind_mph'] ?? 0.0).toDouble(), windKph: (json['wind_kph'] ?? 0.0).toDouble(),
      windDegree: json['wind_degree'] ?? 0, windDir: json['wind_dir'] ?? '',
      pressureMb: (json['pressure_mb'] ?? 0.0).toDouble(), precipMm: (json['precip_mm'] ?? 0.0).toDouble(),
      humidity: json['humidity'] ?? 0, cloud: json['cloud'] ?? 0,
      feelsLikeC: (json['feelslike_c'] ?? 0.0).toDouble(), visKm: (json['vis_km'] ?? 0.0).toDouble(),
      uv: (json['uv'] ?? 0.0).toDouble(),
      airQuality: json['air_quality'] != null ? AirQuality.fromJson(json['air_quality']) : null,
    );
  }
}

class Condition {
  final String text;
  final String icon;
  final int code;

  Condition({required this.text, required this.icon, required this.code});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'] ?? '',
      icon: (json['icon'] as String?)?.startsWith('http') == true 
          ? json['icon'] ?? ''
          : 'https:${json['icon'] ?? ''}',
      code: json['code'] ?? 0,
    );
  }
}

class AirQuality {
  final double co;
  final double no;
  final double no2;
  final double o3;
  final double so2;
  final double pm2_5;
  final double pm10;
  final double usEpaIndex;

  AirQuality({required this.co, required this.no, required this.no2, required this.o3, required this.so2, required this.pm2_5, required this.pm10, required this.usEpaIndex});

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
      co: (json['co'] ?? 0.0).toDouble(), no: (json['no'] ?? 0.0).toDouble(), no2: (json['no2'] ?? 0.0).toDouble(),
      o3: (json['o3'] ?? 0.0).toDouble(), so2: (json['so2'] ?? 0.0).toDouble(),
      pm2_5: (json['pm2_5'] ?? 0.0).toDouble(), pm10: (json['pm10'] ?? 0.0).toDouble(),
      usEpaIndex: (json['us-epa-index'] ?? 0.0).toDouble(),
    );
  }

  String get aqiDescription {
    if (usEpaIndex <= 50) return 'Baik';
    if (usEpaIndex <= 100) return 'Sedang';
    if (usEpaIndex <= 150) return 'Tidak Sehat untuk Kelompok Sensitif';
    if (usEpaIndex <= 200) return 'Tidak Sehat';
    if (usEpaIndex <= 300) return 'Sangat Tidak Sehat';
    return 'Berbahaya';
  }
}

class Forecast {
  final List<ForecastDay> forecastDay;

  Forecast({required this.forecastDay});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    var list = json['forecastday'] as List;
    List<ForecastDay> days = list.map((i) => ForecastDay.fromJson(i)).toList();
    return Forecast(forecastDay: days);
  }
}

class ForecastDay {
  final String date;
  final Day day;
  final Astro astro;
  final List<Hour> hour;

  ForecastDay({required this.date, required this.day, required this.astro, required this.hour});

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    var hourList = json['hour'] as List;
    List<Hour> hours = hourList.map((i) => Hour.fromJson(i)).toList();
    return ForecastDay(
      date: json['date'],
      day: Day.fromJson(json['day']),
      astro: Astro.fromJson(json['astro']),
      hour: hours,
    );
  }
}

class Day {
  final double maxTempC;
  final double minTempC;
  final double avgTempC;
  final Condition condition;
  final double maxWindMph;
  final double totalPrecipMm;
  final double avgHumidity;
  final double uv;
  final int dailyChanceOfRain;

  Day({required this.maxTempC, required this.minTempC, required this.avgTempC, required this.condition, required this.maxWindMph, required this.totalPrecipMm, required this.avgHumidity, required this.uv, required this.dailyChanceOfRain});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxTempC: (json['maxtemp_c'] ?? 0.0).toDouble(), minTempC: (json['mintemp_c'] ?? 0.0).toDouble(),
      avgTempC: (json['avgtemp_c'] ?? 0.0).toDouble(), condition: Condition.fromJson(json['condition'] ?? {}),
      maxWindMph: (json['maxwind_mph'] ?? 0.0).toDouble(), totalPrecipMm: (json['totalprecip_mm'] ?? 0.0).toDouble(),
      avgHumidity: (json['avghumidity'] ?? 0.0).toDouble(), uv: (json['uv'] ?? 0.0).toDouble(),
      dailyChanceOfRain: json['daily_chance_of_rain'] ?? 0,
    );
  }
}

class Astro {
  final String sunrise;
  final String sunset;

  Astro({required this.sunrise, required this.sunset});

  factory Astro.fromJson(Map<String, dynamic> json) {
    return Astro(sunrise: json['sunrise'] ?? '', sunset: json['sunset'] ?? '');
  }
}

class Hour {
  final String time;
  final double tempC;
  final Condition condition;
  final double windKph;
  final int humidity;
  final double chanceOfRain;

  Hour({required this.time, required this.tempC, required this.condition, required this.windKph, required this.humidity, required this.chanceOfRain});

  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(
      time: json['time'] ?? '', tempC: (json['temp_c'] ?? 0.0).toDouble(),
      condition: Condition.fromJson(json['condition'] ?? {}), windKph: (json['wind_kph'] ?? 0.0).toDouble(),
      humidity: json['humidity'] ?? 0, chanceOfRain: (json['chance_of_rain'] ?? 0.0).toDouble(),
    );
  }
}
