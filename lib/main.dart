import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokemon_go/presentation/routes/router_provider.dart';
import 'package:pokemon_go/utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: PokemonGoApp()));
}

class PokemonGoApp extends ConsumerWidget {
  const PokemonGoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeData = ref.watch(themeProvider);
    return MaterialApp.router(
      theme: themeData.light,
      darkTheme: themeData.dark,
      routerConfig: router,
    );
  }
}
