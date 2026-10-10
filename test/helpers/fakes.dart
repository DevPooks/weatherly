import 'dart:async';

import 'package:weatherly/features/favorites/data/favorites_store.dart';
import 'package:weatherly/features/weather/domain/entities/city.dart';
import 'package:weatherly/features/weather/domain/entities/weather_data.dart';
import 'package:weatherly/features/weather/domain/repositories/weather_repository.dart';

const testCity = City(
  id: '1',
  name: 'Santiago',
  latitude: -33.45,
  longitude: -70.66,
  country: 'Chile',
  region: 'Santiago Metropolitan',
);

WeatherData sampleWeather({City city = testCity}) => WeatherData(
  city: city,
  current: CurrentWeather(
    time: DateTime(2026, 10, 10, 14),
    temperatureC: 18,
    apparentTemperatureC: 17,
    humidityPercent: 65,
    windSpeedKmh: 11,
    weatherCode: 2,
  ),
  hourly: [
    HourlyForecast(
      time: DateTime(2026, 10, 10, 14),
      temperatureC: 18,
      weatherCode: 2,
    ),
    HourlyForecast(
      time: DateTime(2026, 10, 10, 15),
      temperatureC: 19,
      weatherCode: 1,
    ),
  ],
  daily: [
    DailyForecast(
      date: DateTime(2026, 10, 10),
      minimumC: 11,
      maximumC: 20,
      weatherCode: 2,
    ),
    DailyForecast(
      date: DateTime(2026, 10, 11),
      minimumC: 9,
      maximumC: 18,
      weatherCode: 61,
    ),
  ],
  timezone: 'America/Santiago',
  fetchedAt: DateTime(2026, 10, 10, 14),
);

class FakeWeatherRepository implements WeatherRepository {
  FakeWeatherRepository({
    WeatherData? weather,
    this.searchResults = const [testCity],
    this.error,
    this.weatherCompleter,
  }) : weather = weather ?? sampleWeather();

  final WeatherData weather;
  final List<City> searchResults;
  final Object? error;
  final Completer<WeatherData>? weatherCompleter;

  @override
  Future<WeatherData> getWeather(City city) async {
    if (weatherCompleter != null) return weatherCompleter!.future;
    if (error != null) throw error!;
    return weather;
  }

  @override
  Future<List<City>> searchCities(String query) async {
    if (error != null) throw error!;
    return searchResults;
  }
}

class InMemoryFavoritesStore implements FavoritesStore {
  InMemoryFavoritesStore([List<City> initial = const []])
    : values = List.of(initial);

  List<City> values;
  int saveCount = 0;

  @override
  Future<List<City>> load() async => List.unmodifiable(values);

  @override
  Future<void> save(List<City> cities) async {
    values = List.of(cities);
    saveCount += 1;
  }
}
