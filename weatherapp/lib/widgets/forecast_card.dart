import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/models/weather_model.dart';

class ForecastCard extends StatelessWidget {
  final ForecastDay forecastDay;

  const ForecastCard({super.key, required this.forecastDay});

  @override
  Widget build(BuildContext context) {
    final day = forecastDay.day;
    final date = DateTime.parse(forecastDay.date);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 60,
              child: Text(DateFormat('EEE').format(date), style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Image.network(day.condition.icon, width: 50, height: 50),
            Expanded(
              child: Text(
                day.condition.text, 
                style: const TextStyle(color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.water_drop, color: Colors.blue, size: 16),
                Text('${day.dailyChanceOfRain}%'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
