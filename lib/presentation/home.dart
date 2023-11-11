import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokemon_go/assets/pokemon_icons.dart';
import 'package:pokemon_go/controller/pokemon_list_provider.dart';
import 'package:pokemon_go/domain/pokemon/model/pokemon_shallow.dart';
import 'package:pokemon_go/presentation/widget/error_header.dart';
import 'package:pokemon_go/utils/constraints.dart';
import 'package:pokemon_go/utils/string_extensions.dart';

void _usePagination({
  required PokemonPagination paging,
  required ScrollController controller,
  double viewportFactor = 0.5,
}) {
  useEffect(() {
    void listenScroll() {
      final position = controller.position;
      if (!paging.isLoading &&
          position.extentAfter <
              (position.viewportDimension * viewportFactor)) {
        paging.retrieveNextPage();
      }
    }

    controller.addListener(listenScroll);
    return () => controller.removeListener(listenScroll);
  }, [controller, paging]);
}

class PokemonHome extends HookConsumerWidget {
  const PokemonHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useScrollController(keys: const []);
    final pokemonNotifier = ref.watch(pokemonPageProvider.notifier);
    _usePagination(paging: pokemonNotifier, controller: controller);
    return Scaffold(
      body: Scrollbar(
        controller: controller,
        child: CustomScrollView(
          controller: controller,
          slivers: const [
            SliverAppBar.medium(
              title: Text('PokeApp'),
              centerTitle: true,
              elevation: 0.0,
            ),
            _PokemonListView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.animateTo(
          0,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubicEmphasized,
        ),
        child: const Icon(Icons.arrow_upward_outlined),
      ),
    );
  }
}

class _PokemonListView extends ConsumerWidget {
  // ignore: use_super_parameters
  const _PokemonListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonPageProvider);
    if (!state.hasValue) {
      if (state.isLoading) {
        final theme = Theme.of(context);
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: SpinKitDoubleBounce(
              color: theme.colorScheme.primary,
              size: 72.0,
            ),
          ),
        );
      } else if (state.hasError) {
        return ErrorHeader(
          title: 'Error al cargar',
          onPressed: () => ref.invalidate(pokemonPageProvider),
        );
      }
    }
    final pokemons = state.valueOrNull;
    bool isValid = pokemons != null && pokemons.isNotEmpty;
    return SliverSafeArea(
      top: false,
      sliver: SliverPadding(
        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) {
              if (isValid && index < pokemons.length) {
                final pokemon = pokemons[index];
                return _PokemonTile(pokemon: pokemon);
              }
              if (index == (pokemons?.length ?? 1)) {
                if (state.isLoading) {
                  return const Align(
                    alignment: Alignment.bottomCenter,
                    child: LinearProgressIndicator(),
                  );
                } else if (state.hasError) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    alignment: Alignment.bottomCenter,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref
                            .read(pokemonPageProvider.notifier)
                            .retrieveNextPage();
                      },
                      icon: const Icon(Icons.restart_alt_outlined),
                      label: const Text('Reintentar'),
                    ),
                  );
                } else if ((pokemons?.isEmpty ?? false) && index == 0) {
                return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Image(
                          image: AssetImage(PokemonIcons.pokeball),
                          height: 72.0,
                          width: 72.0,
                        ),
                        gap24,
                        Text(
                          'There are no pokemons to catch!',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
              } 
              return null;
            },
          ),
        ),
      ),
    );
  }
}

class _PokemonTile extends StatelessWidget {
  final PokemonShallow pokemon;

  const _PokemonTile({
    // ignore: unused_element
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        tileColor: ElevationOverlay.applySurfaceTint(
          scheme.background,
          scheme.surfaceTint,
          4.0,
        ),
        visualDensity: const VisualDensity(vertical: 2.0),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          side: BorderSide(color: scheme.onSurface),
        ),
        leading: const Image(
          image: AssetImage(PokemonIcons.pokeball),
          height: 32.0,
          width: 32.0,
        ),
        minLeadingWidth: 4.0,
        title: Text(
          pokemon.name.toTitleCase(),
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '#${pokemon.id}',
          style: const TextStyle(fontSize: 12.0, color: Color(0xFF666666)),
        ),
        onTap: () => context.pushNamed(
          'pokemon_details',
          pathParameters: {'id': pokemon.id.toString()},
        ),
      ),
    );
  }
}
