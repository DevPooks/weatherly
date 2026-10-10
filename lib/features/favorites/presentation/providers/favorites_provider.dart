import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../weather/domain/entities/city.dart';
import '../../data/favorites_store.dart';

final favoritesStoreProvider = Provider<FavoritesStore>(
  (ref) => SharedPreferencesFavoritesStore(),
);

class FavoritesController extends AsyncNotifier<List<City>> {
  late FavoritesStore _store;

  @override
  Future<List<City>> build() async {
    _store = ref.watch(favoritesStoreProvider);
    return _store.load();
  }

  Future<void> toggle(City city) async {
    final current = state.value ?? await _store.load();
    final updated = current.any((item) => item.id == city.id)
        ? current.where((item) => item.id != city.id).toList(growable: false)
        : [...current, city];
    state = AsyncData(updated);
    try {
      await _store.save(updated);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  bool contains(City city) =>
      state.value?.any((item) => item.id == city.id) ?? false;
}

final favoritesProvider =
    AsyncNotifierProvider<FavoritesController, List<City>>(
      FavoritesController.new,
    );
