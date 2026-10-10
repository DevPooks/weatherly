import 'package:flutter/material.dart';

class WeatherCondition {
  const WeatherCondition(this.label, this.icon);

  final String label;
  final IconData icon;
}

WeatherCondition weatherConditionFor(int code) {
  return switch (code) {
    0 => const WeatherCondition('Clear sky', Icons.wb_sunny_outlined),
    1 => const WeatherCondition('Mostly clear', Icons.wb_sunny_outlined),
    2 => const WeatherCondition('Partly cloudy', Icons.cloud_queue),
    3 => const WeatherCondition('Overcast', Icons.cloud_outlined),
    45 || 48 => const WeatherCondition('Fog', Icons.blur_on),
    51 || 53 || 55 => const WeatherCondition('Drizzle', Icons.grain_outlined),
    56 ||
    57 => const WeatherCondition('Freezing drizzle', Icons.ac_unit_outlined),
    61 || 63 || 65 => const WeatherCondition('Rain', Icons.water_drop_outlined),
    66 || 67 => const WeatherCondition('Freezing rain', Icons.ac_unit_outlined),
    71 ||
    73 ||
    75 ||
    77 => const WeatherCondition('Snow', Icons.ac_unit_outlined),
    80 ||
    81 ||
    82 => const WeatherCondition('Rain showers', Icons.shower_outlined),
    85 || 86 => const WeatherCondition('Snow showers', Icons.ac_unit_outlined),
    95 => const WeatherCondition('Thunderstorm', Icons.thunderstorm_outlined),
    96 ||
    99 => const WeatherCondition('Thunderstorm with hail', Icons.thunderstorm),
    _ => const WeatherCondition('Unknown conditions', Icons.help_outline),
  };
}
