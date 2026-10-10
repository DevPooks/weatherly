import 'package:dio/dio.dart';

import '../../../../core/errors/weather_exception.dart';
import '../../domain/entities/city.dart';
import '../../domain/entities/weather_data.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';
import '../models/city_model.dart';
import '../models/weather_data_model.dart';

class OpenMeteoWeatherRepository implements WeatherRepository {
  const OpenMeteoWeatherRepository(this._remoteDataSource);

  final WeatherRemoteDataSource _remoteDataSource;

  @override
  Future<List<City>> searchCities(String query) async {
    final normalized = query.trim();
    if (normalized.length < 2) return const [];
    try {
      final json = await _remoteDataSource.searchCities(normalized);
      final results = (json['results'] as List?) ?? const [];
      return results
          .cast<Map>()
          .map((item) => CityModel.fromOpenMeteo(item.cast<String, Object?>()))
          .map((model) => model.toEntity())
          .toList(growable: false);
    } on DioException catch (error) {
      throw WeatherException(_messageFor(error), cause: error);
    } on FormatException catch (error) {
      throw WeatherException(
        'The city service returned an unexpected response.',
        cause: error,
      );
    } on TypeError catch (error) {
      throw WeatherException(
        'The city service returned an unexpected response.',
        cause: error,
      );
    }
  }

  @override
  Future<WeatherData> getWeather(City city) async {
    try {
      final json = await _remoteDataSource.fetchWeather(
        latitude: city.latitude,
        longitude: city.longitude,
      );
      return WeatherDataModel.fromOpenMeteo(json).toEntity(city);
    } on DioException catch (error) {
      throw WeatherException(_messageFor(error), cause: error);
    } on FormatException catch (error) {
      throw WeatherException(
        'The weather service returned an unexpected response.',
        cause: error,
      );
    } on TypeError catch (error) {
      throw WeatherException(
        'The weather service returned an unexpected response.',
        cause: error,
      );
    }
  }
}

String _messageFor(DioException error) {
  return switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout =>
      'The weather service took too long to respond.',
    DioExceptionType.connectionError => 'Check your connection and try again.',
    _ => 'We could not load the weather right now.',
  };
}
