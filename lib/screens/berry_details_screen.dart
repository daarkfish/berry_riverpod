import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/berry_providers.dart';

class BerryDetailsScreen extends ConsumerWidget {
  final String berryName;

  const BerryDetailsScreen({super.key, required this.berryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final berryDetailsAsyncValue = ref.watch(berryDetailsProvider(berryName));

    return Scaffold(
      appBar: AppBar(
        title: Text('Berry Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: berryDetailsAsyncValue.when(
        data: (berry) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${berry.name}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('ID: ${berry.id}'),
              Text('Growth Time: ${berry.growthTime} hours'),
              Text('Max Harvest: ${berry.maxHarvest}'),
              Text('Size: ${berry.size} mm'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(berryDetailsProvider(berryName)),
                child: const Text('Refresh Berry Details'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
