import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/weather_remote_data_source.dart';
import '../../data/repositories/open_meteo_weather_repository.dart';
import '../../domain/entities/city.dart';
import '../../domain/entities/weather_data.dart';
import '../../domain/repositories/weather_repository.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSource>(
  (ref) => OpenMeteoRemoteDataSource(ref.watch(dioClientProvider).dio),
);

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) =>
      OpenMeteoWeatherRepository(ref.watch(weatherRemoteDataSourceProvider)),
);

class SelectedCityController extends Notifier<City> {
  @override
  City build() => City.santiago;

  void select(City city) => state = city;
}

final selectedCityProvider = NotifierProvider<SelectedCityController, City>(
  SelectedCityController.new,
);

final weatherProvider = FutureProvider.autoDispose.family<WeatherData, City>(
  (ref, city) => ref.watch(weatherRepositoryProvider).getWeather(city),
);

final citySearchProvider = FutureProvider.autoDispose
    .family<List<City>, String>((ref, query) async {
      final normalized = query.trim();
      if (normalized.length < 2) return const [];
      final repository = ref.watch(weatherRepositoryProvider);
      await Future<void>.delayed(const Duration(milliseconds: 350));
      return repository.searchCities(normalized);
    });
