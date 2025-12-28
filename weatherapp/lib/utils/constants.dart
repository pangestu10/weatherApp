class ApiConstants {
  static const String baseUrl = 'http://api.weatherapi.com/v1';
  static const String apiKey = 'b13d151e832649a8954193859252812'; // API key dari WeatherAPI.com
  
  // WeatherAPI.com Endpoints
  static const String currentWeather = '/current.json';
  static const String forecast = '/forecast.json';
  static const String search = '/search.json';
  static const String history = '/history.json';
  
  // Shared Preferences Keys
  static const String lastCityKey = 'last_city';
  static const String useLocationKey = 'use_location';

  static const String seenOnboardingKey = 'seen_onboarding';
}