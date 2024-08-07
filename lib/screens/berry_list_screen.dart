import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/berry_providers.dart';

class BerryListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final berriesAsyncValue = ref.watch(filteredBerriesProvider);
    final favoriteCount = ref.watch(favoriteBerryCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Berries (Riverpod)'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Favorites: $favoriteCount',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search berries...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
            ),
          ),
          Expanded(
            child: berriesAsyncValue.when(
              data: (berries) => ListView.builder(
                itemCount: berries.length,
                itemBuilder: (context, index) {
                  final berry = berries[index];
                  return ListTile(
                    title: Text(berry.name),
                    subtitle: Text('Growth Time: ${berry.growthTime} hours'),
                    trailing: IconButton(
                      icon: Icon(
                        ref.watch(isBerryFavoriteProvider(berry.id))
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: ref.watch(isBerryFavoriteProvider(berry.id))
                            ? Colors.red
                            : null,
                      ),
                      onPressed:
                          ref.read(toggleFavoriteBerryProvider(berry.id)),
                    ),
                    onTap: () => context.push('/berry-details/${berry.name}'),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
