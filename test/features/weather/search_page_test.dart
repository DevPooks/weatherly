import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/features/weather/presentation/pages/search_page.dart';
import 'package:weatherly/features/weather/presentation/providers/weather_providers.dart';

import '../../helpers/fakes.dart';

void main() {
  testWidgets('shows prompt, loading state, and city results', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(FakeWeatherRepository()),
        ],
        child: const MaterialApp(home: SearchPage()),
      ),
    );

    expect(find.text('Find a city'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Santiago');
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(ListTile),
        matching: find.text('Santiago'),
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Chile'), findsOneWidget);
  });

  testWidgets('shows empty results without a dead end', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(
            FakeWeatherRepository(searchResults: const []),
          ),
        ],
        child: const MaterialApp(home: SearchPage()),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Atlantis');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('No cities found'), findsOneWidget);
  });
}
