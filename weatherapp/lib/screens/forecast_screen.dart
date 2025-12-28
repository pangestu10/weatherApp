import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/weather_provider.dart';
import 'package:weatherapp/widgets/forecast_card.dart';
import 'package:weatherapp/widgets/loading_widget.dart';
import 'package:weatherapp/screens/details_screen.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prakiraan 7 Hari')),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.isLoading) return const LoadingWidget();
          if (weatherProvider.weatherData?.forecast.forecastDay.isEmpty ?? true) {
            return const Center(child: Text('Tidak ada data prakiraan.'));
          }
          
          final forecasts = weatherProvider.weatherData!.forecast.forecastDay;
          return ListView.builder(
            itemCount: forecasts.length,
            itemBuilder: (context, index) {
              final forecast = forecasts[index];
              return InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(forecastDay: forecast))),
                child: ForecastCard(forecastDay: forecast),
              );
            },
          );
        },
      ),
    );
  }
}
