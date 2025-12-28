// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/weather_service.dart';
import 'package:weatherapp/utils/constants.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  
  ForecastResponseModel? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;
  String _currentCity = 'Jakarta';
  bool _useLocation = true;
  Position? _currentPosition;

  // Getters
  ForecastResponseModel? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentCity => _currentCity;
  bool get useLocation => _useLocation;
  Position? get currentPosition => _currentPosition;

  WeatherProvider() {
    _loadPreferencesAndData();
  }

  Future<void> _loadPreferencesAndData() async {
    final prefs = await SharedPreferences.getInstance();
    _currentCity = prefs.getString(ApiConstants.lastCityKey) ?? 'Jakarta';
    _useLocation = prefs.getBool(ApiConstants.useLocationKey) ?? false;
    
    if (_useLocation) {
      await _getCurrentLocationAndFetchWeather();
    } else {
      await fetchWeatherByCity(_currentCity);
    }
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConstants.lastCityKey, _currentCity);
    await prefs.setBool(ApiConstants.useLocationKey, _useLocation);
  }

  Future<void> _getCurrentLocationAndFetchWeather() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _setError('Layanan lokasi dinonaktifkan.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _setError('Izin lokasi ditolak.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _setError('Izin lokasi ditolak secara permanen.');
      return;
    }

    try {
      _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      await fetchWeatherByCoordinates(_currentPosition!.latitude, _currentPosition!.longitude);
    } catch (e) {
      _setError('Gagal mendapatkan lokasi: $e');
    }
  }

  Future<void> fetchWeatherByCity(String cityName) async {
    _setLoading(true);
    try {
      _weatherData = await _weatherService.getWeatherAndForecast(cityName);
      _currentCity = _weatherData!.location.name;
      _errorMessage = null;
      await _savePreferences();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    _setLoading(true);
    try {
      _weatherData = await _weatherService.getWeatherAndForecast('$lat,$lon');
      _currentCity = _weatherData!.location.name;
      _errorMessage = null;
      await _savePreferences();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleLocationService() async {
    _useLocation = !_useLocation;
    notifyListeners();
    if (_useLocation) {
      await _getCurrentLocationAndFetchWeather();
    } else {
      await fetchWeatherByCity(_currentCity);
    }
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}