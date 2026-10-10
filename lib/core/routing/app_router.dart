import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/weather/presentation/pages/city_detail_page.dart';
import '../../features/weather/presentation/pages/home_page.dart';
import '../../features/weather/presentation/pages/invalid_city_page.dart';
import '../../features/weather/presentation/pages/search_page.dart';
import 'city_route.dart';

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesPage(),
      ),
      GoRoute(
        path: '/city/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          final city = id == null
              ? null
              : CityRoute.parse(id, state.uri.queryParameters);
          return city == null
              ? const InvalidCityPage()
              : CityDetailPage(city: city);
        },
      ),
    ],
    errorBuilder: (context, state) => const InvalidCityPage(),
  ),
);
