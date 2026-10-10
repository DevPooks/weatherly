import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/adaptive_page_scaffold.dart';
import '../../../favorites/presentation/widgets/favorite_button.dart';
import '../../domain/entities/city.dart';
import '../providers/weather_providers.dart';
import '../widgets/weather_panel.dart';

class CityDetailPage extends ConsumerStatefulWidget {
  const CityDetailPage({required this.city, super.key});

  final City city;

  @override
  ConsumerState<CityDetailPage> createState() => _CityDetailPageState();
}

class _CityDetailPageState extends ConsumerState<CityDetailPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(selectedCityProvider.notifier).select(widget.city),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptivePageScaffold(
      title: widget.city.name,
      selectedIndex: 0,
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(weatherProvider(widget.city).future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: WeatherPanel(
                  city: widget.city,
                  summaryTrailing: FavoriteButton(
                    city: widget.city,
                    onDark: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
