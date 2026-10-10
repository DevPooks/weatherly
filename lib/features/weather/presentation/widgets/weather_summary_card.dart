import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/weather_data.dart';
import '../utils/weather_code_mapper.dart';

class WeatherSummaryCard extends StatelessWidget {
  const WeatherSummaryCard({required this.data, this.trailing, super.key});

  final WeatherData data;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final condition = weatherConditionFor(data.current.weatherCode);
    final today = data.daily.firstOrNull;
    return Semantics(
      container: true,
      label:
          '${data.city.name}, ${data.current.temperatureC.round()} degrees Celsius, ${condition.label}',
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.atmosphere,
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.city.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.city.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: const Color(0xFFCAD8E5)),
                        ),
                      ],
                    ),
                  ),
                  ?trailing,
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 20,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(condition.icon, color: Colors.white, size: 56),
                  Text(
                    '${data.current.temperatureC.round()}°',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 72,
                      height: 0.95,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                condition.label,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                'Feels like ${data.current.apparentTemperatureC.round()}°'
                '${today == null ? '' : '  •  H ${today.maximumC.round()}°  L ${today.minimumC.round()}°'}',
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: const Color(0xFFCAD8E5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
