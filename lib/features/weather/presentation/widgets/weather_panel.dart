import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/weather_exception.dart';
import '../../../../core/widgets/async_state_views.dart';
import '../../domain/entities/city.dart';
import '../providers/weather_providers.dart';
import 'weather_view.dart';

class WeatherPanel extends ConsumerWidget {
  const WeatherPanel({required this.city, this.summaryTrailing, super.key});

  final City city;
  final Widget? summaryTrailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weatherProvider(city));
    return weather.when(
      loading: () => const LoadingStateView(),
      error: (error, _) => ErrorStateView(
        message: error is WeatherException
            ? error.message
            : 'We could not load the weather right now.',
        onRetry: () => ref.invalidate(weatherProvider(city)),
      ),
      data: (data) => WeatherView(data: data, summaryTrailing: summaryTrailing),
    );
  }
}
