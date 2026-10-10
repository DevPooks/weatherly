import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdaptivePageScaffold extends StatelessWidget {
  const AdaptivePageScaffold({
    required this.title,
    required this.selectedIndex,
    required this.body,
    this.actions,
    super.key,
  });

  final String title;
  final int selectedIndex;
  final Widget body;
  final List<Widget>? actions;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.cloud_outlined),
      selectedIcon: Icon(Icons.cloud),
      label: 'Weather',
    ),
    NavigationDestination(
      icon: Icon(Icons.search_outlined),
      selectedIcon: Icon(Icons.search),
      label: 'Search',
    ),
    NavigationDestination(
      icon: Icon(Icons.favorite_outline),
      selectedIcon: Icon(Icons.favorite),
      label: 'Favorites',
    ),
  ];

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/search');
      case 2:
        context.go('/favorites');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 960;
        final page = Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            actions: actions,
          ),
          body: SafeArea(child: body),
          bottomNavigationBar: useRail
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) => _navigate(context, index),
                  destinations: _destinations,
                ),
        );
        if (!useRail) return page;
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  selectedIndex: selectedIndex,
                  extended: constraints.maxWidth >= 1180,
                  onDestinationSelected: (index) => _navigate(context, index),
                  leading: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Semantics(
                      label: 'Weatherly',
                      child: const Icon(Icons.air, size: 32),
                    ),
                  ),
                  destinations: _destinations
                      .map(
                        (destination) => NavigationRailDestination(
                          icon: destination.icon,
                          selectedIcon: destination.selectedIcon,
                          label: Text(destination.label),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(child: page),
            ],
          ),
        );
      },
    );
  }
}
