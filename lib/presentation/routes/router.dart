import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_go/presentation/details.dart';
import 'package:pokemon_go/presentation/home.dart';
import 'package:pokemon_go/presentation/routes/routes_constants.dart';

GoRouter createRouter({
  String initial = '/',
  bool routerNeglect = true,
  bool debugLogDiagnostics = kDebugMode,
  List<NavigatorObserver>? observers,
}) {
  return GoRouter(
    debugLogDiagnostics: debugLogDiagnostics,
    errorBuilder: (context, __) => Material(
      child: Center(
        child: Text(
          '404',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    ),
    routerNeglect: routerNeglect,
    initialLocation: initial,
    observers: observers,
    routes: [
      GoRoute(
        name: 'home',
        path: homeRoute,
        builder: (_, __) => const PokemonHome(),
        routes: [
          GoRoute(
            name: 'pokemon_details',
            path: '$detailsRoute/:id',
            redirect: (context, state) {
              final id = state.pathParameters['id'];
              if (id == null || int.tryParse(id) == null) {
                return homeRoute;
              }
              return null;
            },
            builder: (_, state) => PokemonDetailsScreen(
              id: int.parse(state.pathParameters['id']!),
            ),
          ),
        ],
      ),
    ],
  );
}
