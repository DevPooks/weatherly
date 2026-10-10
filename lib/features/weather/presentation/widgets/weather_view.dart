import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/weather_data.dart';
import '../utils/weather_code_mapper.dart';
import 'weather_summary_card.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({required this.data, this.summaryTrailing, super.key});

  final WeatherData data;
  final Widget? summaryTrailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WeatherSummaryCard(data: data, trailing: summaryTrailing),
        const SizedBox(height: 16),
        _MetricsGrid(data: data),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final hourly = _HourlyForecastCard(items: data.hourly);
            final daily = _DailyForecastCard(items: data.daily);
            if (constraints.maxWidth < 760) {
              return Column(
                children: [hourly, const SizedBox(height: 16), daily],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: hourly),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: daily),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Updated ${_time(data.fetchedAt)} • ${data.timezone}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.data});

  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: compact ? 0.95 : 1.9,
          children: [
            _MetricTile(
              icon: Icons.thermostat_outlined,
              label: 'Feels like',
              value: '${data.current.apparentTemperatureC.round()}°',
              compact: compact,
            ),
            _MetricTile(
              icon: Icons.water_drop_outlined,
              label: 'Humidity',
              value: '${data.current.humidityPercent}%',
              compact: compact,
            ),
            _MetricTile(
              icon: Icons.air,
              label: 'Wind',
              value: '${data.current.windSpeedKmh.round()} km/h',
              compact: compact,
            ),
          ],
        );
      },
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.compact,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 10 : 14),
        child: Flex(
          direction: compact ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.actionBlue),
            SizedBox(width: compact ? 0 : 10, height: compact ? 8 : 0),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: compact
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: compact ? TextAlign.center : TextAlign.start,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: compact ? TextAlign.center : TextAlign.start,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HourlyForecastCard extends StatelessWidget {
  const _HourlyForecastCard({required this.items});

  final List<HourlyForecast> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Next hours',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 126,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 4),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final condition = weatherConditionFor(item.weatherCode);
                  return Semantics(
                    label:
                        '${_time(item.time)}, ${item.temperatureC.round()} degrees, ${condition.label}',
                    child: SizedBox(
                      width: 78,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            index == 0 ? 'Now' : _time(item.time),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 10),
                          Icon(condition.icon, color: AppColors.actionBlue),
                          const SizedBox(height: 10),
                          Text(
                            '${item.temperatureC.round()}°',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyForecastCard extends StatelessWidget {
  const _DailyForecastCard({required this.items});

  final List<DailyForecast> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Next days', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            for (var index = 0; index < items.length; index++) ...[
              _DailyRow(item: items[index], isToday: index == 0),
              if (index != items.length - 1) const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }
}

class _DailyRow extends StatelessWidget {
  const _DailyRow({required this.item, required this.isToday});

  final DailyForecast item;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final condition = weatherConditionFor(item.weatherCode);
    return Semantics(
      label:
          '${isToday ? 'Today' : _weekday(item.date)}, ${condition.label}, high ${item.maximumC.round()}, low ${item.minimumC.round()}',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Expanded(
              child: Text(
                isToday ? 'Today' : _weekday(item.date),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Icon(condition.icon, color: AppColors.actionBlue, size: 22),
            const SizedBox(width: 20),
            SizedBox(
              width: 82,
              child: Text(
                '${item.maximumC.round()}°  ${item.minimumC.round()}°',
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _time(DateTime dateTime) =>
    '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

String _weekday(DateTime date) => const [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
][date.weekday - 1];
