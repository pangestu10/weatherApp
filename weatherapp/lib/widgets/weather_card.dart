import 'package:flutter/material.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/widgets/rain_effect_widget.dart';

class WeatherCard extends StatelessWidget {
  final ForecastResponseModel weatherData;

  const WeatherCard({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final current = weatherData.current;
    final location = weatherData.location;
    
    // Deteksi kondisi hujan
    final isRaining = _isRainingCondition(current.condition.text);
    final rainIntensity = _calculateRainIntensity(current);

    return RainEffectWidget(
      isRaining: isRaining,
      intensity: rainIntensity,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(location.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('${location.region}, ${location.country}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(current.condition.icon, width: 100, height: 100),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${current.tempC.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
                      Text(current.condition.text, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                      Text('Terasa seperti ${current.feelsLikeC.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailItem(Icons.blind, 'Angin', '${current.windKph.toStringAsFixed(1)} km/h'),
                  _buildDetailItem(Icons.opacity, 'Kelembaban', '${current.humidity}%'),
                  _buildDetailItem(Icons.compress, 'Tekanan', '${current.pressureMb.toStringAsFixed(0)} hPa'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk mendeteksi apakah sedang hujan
  bool _isRainingCondition(String conditionText) {
    final lowerText = conditionText.toLowerCase();
    
    // Keywords yang menandakan hujan
    final rainKeywords = [
      'rain', 'drizzle', 'shower', 'thunderstorm', 
      'light rain', 'moderate rain', 'heavy rain',
      'freezing drizzle', 'freezing rain', 'ice pellets',
      'light drizzle', 'moderate drizzle', 'heavy drizzle',
      'light shower', 'moderate shower', 'heavy shower'
    ];
    
    // Cek apakah keyword hujan ada dalam text kondisi
    for (final keyword in rainKeywords) {
      if (lowerText.contains(keyword)) {
        return true;
      }
    }
    
    return false;
  }

  // Fungsi untuk menghitung intensitas hujan (0.0 - 1.0)
  double _calculateRainIntensity(Current current) {
    final lowerText = current.condition.text.toLowerCase();
    
    // Intensitas berdasarkan deskripsi
    if (lowerText.contains('heavy') || lowerText.contains('thunderstorm')) {
      return 1.0; // Hujan lebat
    } else if (lowerText.contains('moderate')) {
      return 0.7; // Hujan sedang
    } else if (lowerText.contains('light')) {
      return 0.3; // Hujan ringan
    } else if (lowerText.contains('drizzle')) {
      return 0.4; // Gerimis
    } else {
      return 0.5; // Default untuk hujan normal
    }
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {

    return Column(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
