import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/features/weather/domain/entities/city.dart';
import 'package:weatherly/features/weather/presentation/providers/weather_providers.dart';

import '../../helpers/fakes.dart';

void main() {
  test('empty and one-character searches do not call the repository', () async {
    final repository = _CountingRepository();
    final container = ProviderContainer(
      overrides: [weatherRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    expect(await container.read(citySearchProvider('').future), isEmpty);
    expect(await container.read(citySearchProvider('S').future), isEmpty);
    expect(repository.searchCalls, 0);
  });

  test('debounced search exposes matching cities', () async {
    final repository = _CountingRepository();
    final container = ProviderContainer(
      overrides: [weatherRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final results = await container.read(citySearchProvider('Santiago').future);

    expect(results, [testCity]);
    expect(repository.searchCalls, 1);
  });
}

class _CountingRepository extends FakeWeatherRepository {
  int searchCalls = 0;

  @override
  Future<List<City>> searchCities(String query) async {
    searchCalls += 1;
    return super.searchCities(query);
  }
}
