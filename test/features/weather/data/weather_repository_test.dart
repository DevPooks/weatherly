import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weatherly/features/weather/data/repositories/open_meteo_weather_repository.dart';
import 'package:weatherly/features/weather/domain/entities/city.dart';

void main() {
  group('OpenMeteoWeatherRepository', () {
    test('maps geocoding results to typed cities', () async {
      final repository = OpenMeteoWeatherRepository(_FakeRemoteDataSource());

      final cities = await repository.searchCities('Santiago');

      expect(cities, hasLength(1));
      expect(cities.single.name, 'Santiago');
      expect(cities.single.country, 'Chile');
      expect(cities.single.region, 'Santiago Metropolitan');
    });

    test('maps current, hourly, and daily forecasts', () async {
      final repository = OpenMeteoWeatherRepository(_FakeRemoteDataSource());

      final weather = await repository.getWeather(City.santiago);

      expect(weather.current.temperatureC, 18.4);
      expect(weather.current.humidityPercent, 65);
      expect(weather.hourly, hasLength(2));
      expect(weather.daily.single.maximumC, 21);
      expect(weather.timezone, 'America/Santiago');
    });

    test('returns no request for a one-character query', () async {
      final source = _FakeRemoteDataSource();
      final repository = OpenMeteoWeatherRepository(source);

      expect(await repository.searchCities('S'), isEmpty);
      expect(source.searchCalls, 0);
    });
  });
}

class _FakeRemoteDataSource implements WeatherRemoteDataSource {
  int searchCalls = 0;

  @override
  Future<Map<String, Object?>> searchCities(String query) async {
    searchCalls += 1;
    return {
      'results': [
        {
          'id': 3871336,
          'name': 'Santiago',
          'latitude': -33.45694,
          'longitude': -70.64827,
          'country': 'Chile',
          'country_code': 'CL',
          'admin1': 'Santiago Metropolitan',
          'timezone': 'America/Santiago',
        },
      ],
    };
  }

  @override
  Future<Map<String, Object?>> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    return {
      'timezone': 'America/Santiago',
      'current': {
        'time': '2026-10-10T14:00',
        'temperature_2m': 18.4,
        'apparent_temperature': 17.1,
        'relative_humidity_2m': 65,
        'wind_speed_10m': 11.2,
        'weather_code': 2,
      },
      'hourly': {
        'time': ['2026-10-10T14:00', '2026-10-10T15:00'],
        'temperature_2m': [18.4, 19.0],
        'weather_code': [2, 1],
      },
      'daily': {
        'time': ['2026-10-10'],
        'temperature_2m_min': [10.5],
        'temperature_2m_max': [21.0],
        'weather_code': [2],
      },
    };
  }
}
