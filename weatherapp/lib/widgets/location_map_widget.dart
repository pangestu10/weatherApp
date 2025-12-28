import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMapWidget extends StatelessWidget {
  final double latitude;
  final double longitude;

  const LocationMapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      // Berikan tinggi tetap pada peta agar tidak bermasalah dengan layout
      child: SizedBox(
        height: 300, // Anda bisa sesuaikan tingginya
        child: FlutterMap(
          options: MapOptions(
            // Atur titik tengah peta ke lokasi cuaca
            initialCenter: LatLng(latitude, longitude),
            initialZoom: 10.0, // Level zoom untuk melihat kota
          ),
          // Nonaktifkan rotasi dan geser dengan 2 jari jika tidak perlu
          // agar lebih mudah digunakan
          // interactionOptions 

          children: [
            // Layer untuk menampilkan petanya (OpenStreetMap)
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
 
              // Penting untuk mengikuti aturan penggunaan OpenStreetMap
              userAgentPackageName: 'com.example.weather_app', 
              maxZoom: 19,
            ),
            // Layer untuk menampilkan marker (pin)
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(latitude, longitude),
                  width: 80,
                  height: 80,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.redAccent,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
