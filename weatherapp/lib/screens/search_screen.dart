import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _textController = TextEditingController();
  final List<String> _allCities = ['Jakarta', 'Surabaya', 'Bandung', 'Medan', 'Semarang', 'Makassar', 'Palembang', 'Tangerang', 'Depok', 'Bekasi', 'Batam', 'Pekanbaru', 'Bandar Lampung', 'Malang', 'Yogyakarta', 'Denpasar', 'Balikpapan', 'Samarinda', 'Pontianak', 'Manado', 'Mataram', 'Kupang', 'Jayapura', 'Ambon', 'Ternate'];
  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = _allCities;
    _textController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onSearchChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _textController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCities = _allCities;
      } else {
        _filteredCities = _allCities
            .where((city) => city.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Kota')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Nama Kota',
                suffixIcon: IconButton(icon: const Icon(Icons.clear), onPressed: () {
                  _textController.clear();
                }),
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              onChanged: (_) => _onSearchChanged(),
              onSubmitted: (_) => _searchAndPop(context),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredCities.isEmpty
                  ? const Center(
                      child: Text(
                        'Kota tidak ditemukan',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredCities.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: const Icon(Icons.location_city, color: Colors.blueAccent),
                        title: Text(
                          _filteredCities[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Provider.of<WeatherProvider>(context, listen: false)
                              .fetchWeatherByCity(_filteredCities[index]);
                          Navigator.pop(context);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _searchAndPop(BuildContext context) {
    if (_textController.text.isNotEmpty) {
      Provider.of<WeatherProvider>(context, listen: false).fetchWeatherByCity(_textController.text);
      Navigator.pop(context);
    }
  }
}
