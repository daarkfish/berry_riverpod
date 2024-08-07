import 'package:berry_riverpod/providers/berry_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:berry_riverpod/models/berry_model.dart';
import 'package:berry_riverpod/services/api_service.dart';

class MockApiService implements ApiService {
  final List<Berry> _berries = [
    Berry(id: 1, name: 'Cheri', growthTime: 3, maxHarvest: 5, size: 20),
    Berry(id: 2, name: 'Chesto', growthTime: 3, maxHarvest: 5, size: 80),
    Berry(id: 3, name: 'Pecha', growthTime: 3, maxHarvest: 5, size: 40),
    Berry(id: 4, name: 'Rawst', growthTime: 3, maxHarvest: 5, size: 32),
    Berry(id: 5, name: 'Aspear', growthTime: 3, maxHarvest: 5, size: 50),
  ];

  @override
  Future<List<Berry>> getBerries() async {
    return _berries;
  }

  @override
  Future<Berry> getBerryDetails(String name) async {
    return _berries.firstWhere(
        (berry) => berry.name.toLowerCase() == name.toLowerCase(),
        orElse: () => throw Exception('Berry not found'));
  }

  @override
  Future<List<Berry>> searchBerries(String query) async {
    return _berries
        .where(
            (berry) => berry.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

void main() {
  test('filteredBerriesProvider returns all berries when query is empty',
      () async {
    final container = ProviderContainer(
      overrides: [
        apiServiceProvider.overrideWithValue(MockApiService()),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(filteredBerriesProvider),
      isA<AsyncLoading<List<Berry>>>(),
    );

    await container.read(filteredBerriesProvider.future);

    final berries = container.read(filteredBerriesProvider).value;
    expect(berries, isNotNull);
    expect(berries!.length, 5);
  });

  test(
      'filteredBerriesProvider returns filtered berries when query is not empty',
      () async {
    final container = ProviderContainer(
      overrides: [
        apiServiceProvider.overrideWithValue(MockApiService()),
      ],
    );
    addTearDown(container.dispose);

    container.read(searchQueryProvider.notifier).state = 'che';

    final filteredBerries =
        await container.read(filteredBerriesProvider.future);
    expect(filteredBerries.length, 2);
    expect(filteredBerries.map((b) => b.name).toList(), ['Cheri', 'Chesto']);
  });

  test('favoriteBerryCountProvider returns correct count', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(favoriteBerryCountProvider), 0);

    container.read(favoriteBerryIdsProvider.notifier).state = {1, 2, 3};

    expect(container.read(favoriteBerryCountProvider), 3);
  });
}
