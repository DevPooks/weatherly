import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../weather/domain/entities/city.dart';
import '../providers/favorites_provider.dart';

class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({required this.city, this.onDark = false, super.key});

  final City city;
  final bool onDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.value?.contains(city) ?? false;
    return IconButton(
      onPressed: favorites.isLoading
          ? null
          : () => ref.read(favoritesProvider.notifier).toggle(city),
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      color: onDark ? Colors.white : null,
      disabledColor: onDark ? Colors.white54 : null,
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_outline),
    );
  }
}
