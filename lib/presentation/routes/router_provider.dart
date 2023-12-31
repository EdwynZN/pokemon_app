import 'package:go_router/go_router.dart';
import 'package:pokemon_go/presentation/routes/router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_provider.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) {
  return createRouter();
}
