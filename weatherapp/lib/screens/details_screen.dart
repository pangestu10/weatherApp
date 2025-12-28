import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/models/weather_model.dart';

class DetailsScreen extends StatelessWidget {
  final ForecastDay forecastDay;
  const DetailsScreen({super.key, required this.forecastDay});

  @override
  Widget build(BuildContext context) {
    final day = forecastDay.day;
    final astro = forecastDay.astro;
    final date = DateTime.parse(forecastDay.date);

    return Scaffold(
      appBar: AppBar(title: Text(DateFormat('EEEE, d MMMM yyyy').format(date))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMainCard(day),
            const SizedBox(height: 20),
            _buildDetailCard(day),
            const SizedBox(height: 20),
            _buildAstroCard(astro),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(Day day) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.network(day.condition.icon, width: 150, height: 150),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${day.maxTempC.toStringAsFixed(1)}°', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const Text(' / ', style: TextStyle(fontSize: 32)),
              Text('${day.minTempC.toStringAsFixed(1)}°', style: const TextStyle(fontSize: 32, color: Colors.grey)),
            ]),
            Text(day.condition.text, style: const TextStyle(fontSize: 24, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(Day day) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detail Informasi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildDetailRow(Icons.air, 'Angin Maks', '${day.maxWindMph.toStringAsFixed(1)} mph'),
            _buildDetailRow(Icons.water_drop, 'Curah Hujan', '${day.totalPrecipMm.toStringAsFixed(1)} mm'),
            _buildDetailRow(Icons.water, 'Kelembaban Rata-rata', '${day.avgHumidity.toStringAsFixed(0)}%'),
            _buildDetailRow(Icons.sunny, 'UV Index', day.uv.toStringAsFixed(1)),
          ],
        ),
      ),
    );
  }

  Widget _buildAstroCard(Astro astro) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Matahari', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildDetailRow(Icons.wb_sunny, 'Matahari Terbit', astro.sunrise),
            _buildDetailRow(Icons.wb_twilight, 'Matahari Terbenam', astro.sunset),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(children: [Icon(icon, color: Colors.blueAccent, size: 24), const SizedBox(width: 16), Expanded(child: Text(label, style: const TextStyle(fontSize: 16))), Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
    );
  }
}
