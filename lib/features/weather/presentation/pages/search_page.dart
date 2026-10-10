import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/weather_exception.dart';
import '../../../../core/routing/city_route.dart';
import '../../../../core/widgets/adaptive_page_scaffold.dart';
import '../../../../core/widgets/async_state_views.dart';
import '../../domain/entities/city.dart';
import '../providers/weather_providers.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(City city) {
    ref.read(selectedCityProvider.notifier).select(city);
    context.go(CityRoute.location(city));
  }

  @override
  Widget build(BuildContext context) {
    final normalized = _query.trim();
    final search = ref.watch(citySearchProvider(normalized));
    return AdaptivePageScaffold(
      title: 'Search cities',
      selectedIndex: 1,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  autofocus: MediaQuery.sizeOf(context).width >= 600,
                  decoration: InputDecoration(
                    hintText: 'Search by city name…',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _controller.clear();
                              setState(() => _query = '');
                            },
                            tooltip: 'Clear search',
                            icon: const Icon(Icons.close),
                          ),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: normalized.length < 2
                      ? const EmptyStateView(
                          icon: Icons.travel_explore,
                          title: 'Find a city',
                          message: 'Enter at least two characters. Region and country are shown when names match.',
                        )
                      : search.when(
                          loading: () => const LoadingStateView(
                            label: 'Searching cities…',
                          ),
                          error: (error, _) => ErrorStateView(
                            message: error is WeatherException
                                ? error.message
                                : 'We could not search for cities right now.',
                            onRetry: () =>
                                ref.invalidate(citySearchProvider(normalized)),
                          ),
                          data: (cities) => cities.isEmpty
                              ? const EmptyStateView(
                                  icon: Icons.location_searching,
                                  title: 'No cities found',
                                  message: 'Check the spelling or try a nearby larger city.',
                                )
                              : _SearchResults(
                                  cities: cities,
                                  onSelected: _select,
                                ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.cities, required this.onSelected});

  final List<City> cities;
  final ValueChanged<City> onSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.separated(
        itemCount: cities.length,
        separatorBuilder: (_, _) => const Divider(height: 1, indent: 64),
        itemBuilder: (context, index) {
          final city = cities[index];
          return ListTile(
            minTileHeight: 64,
            leading: const Icon(Icons.location_on_outlined),
            title: Text(city.name),
            subtitle: Text(city.subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onSelected(city),
          );
        },
      ),
    );
  }
}
