class ForecastModel {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;
  final double windSpeed;
  final int humidity;

  ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.humidity,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'],
    );
  }
}

class ForecastResponse {
  final List<ForecastModel> forecasts;
  final String cityName;

  ForecastResponse({required this.forecasts, required this.cityName});

  factory ForecastResponse.fromJson(Map<String, dynamic> json) {
    var list = json['list'] as List;
    List<ForecastModel> forecasts = list.map((i) => ForecastModel.fromJson(i)).toList();
    
    return ForecastResponse(
      forecasts: forecasts,
      cityName: json['city']['name'],
    );
  }
}