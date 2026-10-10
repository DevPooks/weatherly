import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/features/favorites/presentation/pages/favorites_page.dart';
import 'package:weatherly/features/favorites/presentation/providers/favorites_provider.dart';

import '../../helpers/fakes.dart';

void main() {
  testWidgets('shows an actionable empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoritesStoreProvider.overrideWithValue(InMemoryFavoritesStore()),
        ],
        child: const MaterialApp(home: FavoritesPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No favorites yet'), findsOneWidget);
    expect(find.text('Search cities'), findsOneWidget);
  });

  testWidgets('shows and removes a persisted favorite', (tester) async {
    final store = InMemoryFavoritesStore([testCity]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [favoritesStoreProvider.overrideWithValue(store)],
        child: const MaterialApp(home: FavoritesPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Santiago'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove Santiago from favorites'));
    await tester.pumpAndSettle();

    expect(find.text('No favorites yet'), findsOneWidget);
    expect(store.values, isEmpty);
  });
}
