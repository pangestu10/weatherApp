class AirQualityModel {
  final int aqi;
  final double co;
  final double no;
  final double no2;
  final double o3;
  final double so2;
  final double pm2_5;
  final double pm10;
  final double nh3;

  AirQualityModel({
    required this.aqi,
    required this.co,
    required this.no,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
    required this.nh3,
  });

  factory AirQualityModel.fromJson(Map<String, dynamic> json) {
    return AirQualityModel(
      aqi: json['main']['aqi'],
      co: json['components']['co'].toDouble(),
      no: json['components']['no'].toDouble(),
      no2: json['components']['no2'].toDouble(),
      o3: json['components']['o3'].toDouble(),
      so2: json['components']['so2'].toDouble(),
      pm2_5: json['components']['pm2_5'].toDouble(),
      pm10: json['components']['pm10'].toDouble(),
      nh3: json['components']['nh3'].toDouble(),
    );
  }

  String get aqiDescription {
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Unknown';
    }
  }
}