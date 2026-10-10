import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/features/weather/domain/entities/city.dart';
import 'package:weatherly/features/weather/presentation/providers/weather_providers.dart';

import '../../helpers/fakes.dart';

void main() {
  test('selected city starts at Santiago and can be changed', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    const city = City(
      id: '2',
      name: 'Valparaíso',
      latitude: -33.04,
      longitude: -71.62,
      country: 'Chile',
    );

    expect(container.read(selectedCityProvider), City.santiago);
    container.read(selectedCityProvider.notifier).select(city);
    expect(container.read(selectedCityProvider), city);
  });

  test('weather provider exposes repository data', () async {
    final repository = FakeWeatherRepository();
    final container = ProviderContainer(
      overrides: [weatherRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final weather = await container.read(weatherProvider(testCity).future);

    expect(weather.city, testCity);
    expect(weather.current.temperatureC, 18);
  });
}
