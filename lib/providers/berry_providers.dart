import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/berry_model.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final berriesProvider = FutureProvider<List<Berry>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getBerries();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredBerriesProvider = FutureProvider<List<Berry>>((ref) async {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final berries = await ref.watch(berriesProvider.future);
  if (query.isEmpty) {
    return berries;
  } else {
    return berries
        .where((berry) => berry.name.toLowerCase().contains(query))
        .toList();
  }
});

final favoriteBerryIdsProvider = StateProvider<Set<int>>((ref) => {});

final isBerryFavoriteProvider = Provider.family<bool, int>((ref, berryId) {
  final favoriteIds = ref.watch(favoriteBerryIdsProvider);
  return favoriteIds.contains(berryId);
});

final favoriteBerryCountProvider = Provider<int>((ref) {
  final favoriteIds = ref.watch(favoriteBerryIdsProvider);
  return favoriteIds.length;
});

final toggleFavoriteBerryProvider =
    Provider.family<void Function(), int>((ref, berryId) {
  return () {
    ref.read(favoriteBerryIdsProvider.notifier).update((state) {
      if (state.contains(berryId)) {
        return state.difference({berryId});
      } else {
        return state.union({berryId});
      }
    });
  };
});

final berryDetailsProvider =
    FutureProvider.family<Berry, String>((ref, name) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getBerryDetails(name);
});
