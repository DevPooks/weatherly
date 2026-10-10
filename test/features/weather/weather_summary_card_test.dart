import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/features/weather/presentation/widgets/weather_summary_card.dart';

import '../../helpers/fakes.dart';

void main() {
  testWidgets('shows the typed current weather summary', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: WeatherSummaryCard(data: sampleWeather())),
      ),
    );

    expect(find.text('Santiago'), findsOneWidget);
    expect(find.text('18°'), findsOneWidget);
    expect(find.text('Partly cloudy'), findsOneWidget);
    expect(find.textContaining('Feels like 17°'), findsOneWidget);
  });
}
