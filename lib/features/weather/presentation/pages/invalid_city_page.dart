import 'package:flutter/material.dart';

import '../../../../core/widgets/adaptive_page_scaffold.dart';
import '../../../../core/widgets/async_state_views.dart';

class InvalidCityPage extends StatelessWidget {
  const InvalidCityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdaptivePageScaffold(
      title: 'City unavailable',
      selectedIndex: 0,
      body: EmptyStateView(
        icon: Icons.location_off_outlined,
        title: 'This city link is incomplete',
        message: 'Search for the city again to load its current weather.',
      ),
    );
  }
}
