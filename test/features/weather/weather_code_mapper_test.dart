import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/features/weather/presentation/utils/weather_code_mapper.dart';

void main() {
  test('maps representative WMO codes to labels and icons', () {
    expect(weatherConditionFor(0).label, 'Clear sky');
    expect(weatherConditionFor(61).label, 'Rain');
    expect(weatherConditionFor(95).icon, Icons.thunderstorm_outlined);
  });

  test('does not expose unknown numeric codes to users', () {
    final condition = weatherConditionFor(999);

    expect(condition.label, 'Unknown conditions');
    expect(condition.label, isNot(contains('999')));
  });
}
