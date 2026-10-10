import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/core/errors/weather_exception.dart';
import 'package:weatherly/features/weather/domain/entities/weather_data.dart';
import 'package:weatherly/features/weather/presentation/providers/weather_providers.dart';
import 'package:weatherly/features/weather/presentation/widgets/weather_panel.dart';

import '../../helpers/fakes.dart';

void main() {
  testWidgets('shows loading, success, and error states', (tester) async {
    final completer = Completer<WeatherData>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(
            FakeWeatherRepository(weatherCompleter: completer),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: WeatherPanel(city: testCity)),
          ),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(sampleWeather());
    await tester.pumpAndSettle();
    expect(find.text('Santiago'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(
            FakeWeatherRepository(
              error: const WeatherException('Check your connection.'),
            ),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: WeatherPanel(city: testCity)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Check your connection.'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });
}
