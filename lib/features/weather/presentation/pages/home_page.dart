import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/adaptive_page_scaffold.dart';
import '../../../favorites/presentation/widgets/favorite_button.dart';
import '../providers/weather_providers.dart';
import '../widgets/weather_panel.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final city = ref.watch(selectedCityProvider);
    return AdaptivePageScaffold(
      title: 'Weatherly',
      selectedIndex: 0,
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(weatherProvider(city).future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: WeatherPanel(
                  city: city,
                  summaryTrailing: FavoriteButton(city: city, onDark: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
