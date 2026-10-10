import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../weather/domain/entities/city.dart';

abstract interface class FavoritesStore {
  Future<List<City>> load();

  Future<void> save(List<City> cities);
}

class SharedPreferencesFavoritesStore implements FavoritesStore {
  static const _key = 'favorite_cities_v1';

  @override
  Future<List<City>> load() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString(_key);
    if (encoded == null) return const [];
    try {
      return (jsonDecode(encoded) as List)
          .cast<Map>()
          .map((item) => City.fromJson(item.cast<String, Object?>()))
          .toList(growable: false);
    } on FormatException {
      return const [];
    } on TypeError {
      return const [];
    }
  }

  @override
  Future<void> save(List<City> cities) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _key,
      jsonEncode(cities.map((city) => city.toJson()).toList()),
    );
  }
}
