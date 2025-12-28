import 'package:dio/dio.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/utils/constants.dart';

class WeatherService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  // Mengambil data cuaca dan forecast sekaligus untuk efisiensi
  Future<ForecastResponseModel> getWeatherAndForecast(String query) async {
    try {
      Response response = await _dio.get(
        ApiConstants.forecast,
        queryParameters: {
          'key': ApiConstants.apiKey,
          'q': query,
          'days': 7, // Ambil data 7 hari
          'aqi': 'yes', // Sertakan data kualitas udara
          'alerts': 'no',
        },
      );
      return ForecastResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      // Cetak error untuk debugging
      throw Exception('Gagal memuat data cuaca: ${e.message}');
    }
  }
}