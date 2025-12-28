import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/weather_provider.dart';
import 'package:weatherapp/widgets/weather_card.dart';
import 'package:weatherapp/widgets/loading_widget.dart';
import 'package:weatherapp/widgets/location_map_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App', style: TextStyle(fontWeight: FontWeight.w700),),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => Navigator.pushNamed(context, '/search')),
          Consumer<WeatherProvider>(
            builder: (context, provider, child) => IconButton(
              icon: Icon(provider.useLocation ? Icons.location_on : Icons.location_off),
              onPressed: () => provider.toggleLocationService(),
            ),
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.isLoading) return const LoadingWidget();
          
          if (weatherProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${weatherProvider.errorMessage}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () => weatherProvider.clearError(), child: const Text('Coba Lagi')),
                ],
              ),
            );
          }
          
          if (weatherProvider.weatherData == null) return const Center(child: Text('Tidak ada data cuaca.'));
          
          final data = weatherProvider.weatherData!;
          return SingleChildScrollView(
            child: Column(
              children: [
                WeatherCard(weatherData: data),
                
                // Peta
                LocationMapWidget(
                  latitude: data.location.lat,
                  longitude: data.location.lon,
                ),
                
                if (data.current.airQuality != null)
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: ListTile(
                      leading: const Icon(Icons.air, color: Colors.orange),
                      title: const Text('Kualitas Udara'),
                      subtitle: Text('Index: ${data.current.airQuality!.usEpaIndex.toInt()} - ${data.current.airQuality!.aqiDescription}'),
                    ),
                  ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/forecast'),
                  child: const Text('Lihat Prakiraan 7 Hari'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
