import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/city_route.dart';
import '../../../../core/widgets/adaptive_page_scaffold.dart';
import '../../../../core/widgets/async_state_views.dart';
import '../../../weather/domain/entities/city.dart';
import '../../../weather/presentation/providers/weather_providers.dart';
import '../providers/favorites_provider.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  void _open(BuildContext context, WidgetRef ref, City city) {
    ref.read(selectedCityProvider.notifier).select(city);
    context.go(CityRoute.location(city));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    return AdaptivePageScaffold(
      title: 'Favorites',
      selectedIndex: 2,
      body: favorites.when(
        loading: () => const LoadingStateView(label: 'Loading favorites…'),
        error: (_, _) => ErrorStateView(
          message: 'We could not load your saved cities.',
          onRetry: () => ref.invalidate(favoritesProvider),
        ),
        data: (cities) => cities.isEmpty
            ? EmptyStateView(
                icon: Icons.favorite_outline,
                title: 'No favorites yet',
                message: 'Save cities from their weather screen for quick access here.',
                action: FilledButton.icon(
                  onPressed: () => context.go('/search'),
                  icon: const Icon(Icons.search),
                  label: const Text('Search cities'),
                ),
              )
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    itemCount: cities.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final city = cities[index];
                      return Card(
                        child: ListTile(
                          minTileHeight: 72,
                          leading: const CircleAvatar(
                            child: Icon(Icons.cloud_outlined),
                          ),
                          title: Text(city.name),
                          subtitle: Text(city.subtitle),
                          onTap: () => _open(context, ref, city),
                          trailing: IconButton(
                            onPressed: () => ref
                                .read(favoritesProvider.notifier)
                                .toggle(city),
                            tooltip: 'Remove ${city.name} from favorites',
                            icon: const Icon(Icons.favorite),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
