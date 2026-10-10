import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/features/favorites/presentation/providers/favorites_provider.dart';

import '../../helpers/fakes.dart';

void main() {
  test('loads, adds, removes, and persists favorite cities', () async {
    final store = InMemoryFavoritesStore();
    final container = ProviderContainer(
      overrides: [favoritesStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);

    expect(await container.read(favoritesProvider.future), isEmpty);

    await container.read(favoritesProvider.notifier).toggle(testCity);
    expect(container.read(favoritesProvider).value, [testCity]);
    expect(store.values, [testCity]);

    await container.read(favoritesProvider.notifier).toggle(testCity);
    expect(container.read(favoritesProvider).value, isEmpty);
    expect(store.saveCount, 2);
  });
}
