import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/berry_list_screen.dart';
import 'screens/berry_details_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: BerryRiverpod(),
    ),
  );
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BerryListScreen(),
    ),
    GoRoute(
      path: '/berry-details/:name',
      builder: (context, state) {
        final berryName = state.pathParameters['name']!;
        return BerryDetailsScreen(berryName: berryName);
      },
    ),
  ],
);

class BerryRiverpod extends StatelessWidget {
  const BerryRiverpod({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Berry App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: router,
    );
  }
}
