import 'package:dio/dio.dart';

abstract interface class WeatherRemoteDataSource {
  Future<Map<String, Object?>> searchCities(String query);

  Future<Map<String, Object?>> fetchWeather({
    required double latitude,
    required double longitude,
  });
}

class OpenMeteoRemoteDataSource implements WeatherRemoteDataSource {
  const OpenMeteoRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<Map<String, Object?>> searchCities(String query) async {
    final response = await _dio.get<Map<String, Object?>>(
      'https://geocoding-api.open-meteo.com/v1/search',
      queryParameters: {
        'name': query,
        'count': 10,
        'language': 'en',
        'format': 'json',
      },
    );
    return response.data ?? const {};
  }

  @override
  Future<Map<String, Object?>> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _dio.get<Map<String, Object?>>(
      'https://api.open-meteo.com/v1/forecast',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'current': [
          'temperature_2m',
          'apparent_temperature',
          'relative_humidity_2m',
          'weather_code',
          'wind_speed_10m',
        ].join(','),
        'hourly': ['temperature_2m', 'weather_code'].join(','),
        'daily': [
          'weather_code',
          'temperature_2m_max',
          'temperature_2m_min',
        ].join(','),
        'timezone': 'auto',
        'forecast_days': 7,
      },
    );
    return response.data ?? const {};
  }
}
