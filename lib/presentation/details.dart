import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokemon_go/assets/pokemon_icons.dart';
import 'package:pokemon_go/controller/pokemon_details_provider.dart';
import 'package:pokemon_go/domain/pokemon/model/pokemon.dart';
import 'package:pokemon_go/infrastructure/cache_manager.dart';
import 'package:pokemon_go/presentation/widget/bloc_sliver.dart';
import 'package:pokemon_go/presentation/widget/type_chip.dart';
import 'package:pokemon_go/utils/constraints.dart';
import 'package:pokemon_go/utils/string_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonDetailsScreen extends HookConsumerWidget {
  final int id;

  const PokemonDetailsScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController(keys: const []);
    final showFABState = useState(false);
    useEffect(() {
      void listenScroll() {
        final position = scrollController.position;
        if (position.extentBefore > (position.viewportDimension / 2)) {
          showFABState.value = true;
        } else {
          showFABState.value = false;
        }
      }

      scrollController.addListener(listenScroll);
      return () => scrollController.removeListener(listenScroll);
    }, [scrollController, showFABState]);
    final detail = ref.watch(pokemonDetailsProvider(id: id));
    final name = detail.maybeWhen(
      data: (data) => data.name.toTitleCase(),
      orElse: () => null,
    );
    final list = detail.when(
      loading: () => const [
        SliverToBoxAdapter(
          child: LinearProgressIndicator(minHeight: 8.0),
        ),
      ],
      error: (error, stackTrace) {
        return const [
          SliverToBoxAdapter(),
        ];
      },
      data: (data) => [
        _DetailPokemonCard(
          image: data.sprite.front,
          id: id,
          pokemnoHeight: data.height,
          pokemnoWeight: data.weight,
          xp: data.baseExperience,
        ),
        const SliverToBoxAdapter(child: gap8),
        _TypesWidget(types: data.types),
        const SliverToBoxAdapter(child: gap8),
        _StatsSiLiver(stats: data.stats),
        const SliverToBoxAdapter(child: gap8),
        _AbilitiesSiLiver(abilities: data.abilities),
        const SliverToBoxAdapter(child: gap8),
        SliverSafeArea(
          top: false,
          sliver: _MovesSiLiver(moves: data.movements),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: name == null ? null : Text(name),
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: list,
      ),
      floatingActionButton: showFABState.value
          ? FloatingActionButton(
              onPressed: () => scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOutCubicEmphasized,
              ),
              child: const Icon(Icons.arrow_upward_outlined),
            )
          : null,
    );
  }
}

class _TypesWidget extends HookWidget {
  final List<PokemonType> types;

  // ignore: unused_element
  const _TypesWidget({super.key, required this.types});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = useMemoized(
      () {
        return types
            .map(
              (t) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: TypeChip(
                  name: t.name.toTitleCase(),
                  color: switch (t.name) {
                    'grass' => Colors.green.shade600,
                    'water' => Colors.blue.shade600,
                    'poison' => Colors.purple.shade600,
                    'fire' => Colors.orange.shade600,
                    _ => Colors.grey.shade600,
                  },
                ),
              ),
            )
            .toList();
      },
      types,
    );
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 32.0,
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}

class _DetailPokemonCard extends StatelessWidget {
  final String image;
  final int id;
  final int pokemnoHeight;
  final int pokemnoWeight;
  final int xp;

  const _DetailPokemonCard({
    // ignore: unused_element
    super.key,
    required this.image,
    required this.id,
    required this.pokemnoHeight,
    required this.pokemnoWeight,
    required this.xp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final asset = Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          width: 140.0,
          height: 140.0,
        ),
        child: Consumer(
          builder: (BuildContext context, WidgetRef ref, _) {
            return CachedNetworkImage(
              memCacheHeight: 140,
              height: 140,
              width: 120,
              memCacheWidth: 120,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              cacheManager: ref.watch(
                cacheManagerProvider(cacheKey: 'Pokemon'),
              ),
              imageUrl: image,
              placeholder: (_, __) => const Center(
                child: Image(
                  image: AssetImage(PokemonIcons.pokeball),
                  height: 32.0,
                  width: 32.0,
                ),
              ),
            );
          },
        ),
      ),
    );

    final Widget info = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '#$id',
          style: const TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.w600,
            height: 0.0,
          ),
          maxLines: 1,
        ),
        gap8,
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: Card(
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _RowTable(
                    title: 'Height',
                    detail: '${pokemnoHeight * 10} cm',
                  ),
                  const Divider(height: 16.0),
                  _RowTable(
                    title: 'Weight',
                    detail: '${pokemnoWeight / 10} kg',
                  ),
                  const Divider(height: 16.0),
                  _RowTable(
                    title: 'Base XP',
                    detail: '${pokemnoHeight * 10} xp',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    final Widget child = DefaultTextStyle.merge(
      style: TextStyle(color: theme.colorScheme.onSecondaryContainer),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            asset,
            gap12,
            Expanded(child: info),
          ],
        ),
      ),
    );

    return SliverToBoxAdapter(
      child: Card(
        elevation: 0.0,
        color: theme.colorScheme.secondaryContainer.withOpacity(0.36),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          side: BorderSide(
            color: theme.colorScheme.secondary,
            width: 1.5,
          ),
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        child: child,
      ),
    );
  }
}

class _RowTable extends StatelessWidget {
  final String title;
  final String detail;
  // ignore: unused_element
  const _RowTable({super.key, required this.detail, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            height: 0.0,
          ),
          maxLines: 1,
        ),
        const Spacer(),
        Text(
          detail,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            height: 0.0,
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}

class _StatsSiLiver extends HookWidget {
  final List<Stat> stats;

  // ignore: unused_element
  const _StatsSiLiver({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final color = theme.colorScheme.tertiary;
    final List<TableRow> list = useMemoized(() {
      const style = TextStyle(
        wordSpacing: 0.15,
        letterSpacing: 0.15,
        fontWeight: FontWeight.bold,
      );
      return stats
          .map(
            (s) => TableRow(
              children: [
                Text(
                  '${s.name.toUpperCase()} (${s.value})',
                  style: style,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  padding: const EdgeInsets.all(6.0),
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: color.withOpacity(0.24),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: LinearProgressIndicator(
                      minHeight: 8.0,
                      backgroundColor: Colors.transparent,
                      color: color,
                      value: s.value / 200,
                    ),
                  ),
                ),
              ],
            ),
          )
          .toList();
    }, [color, ...stats]);
    final child = DefaultTextStyle.merge(
      style: textTheme.bodyLarge,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(),
          1: MaxColumnWidth(
            FixedColumnWidth(150.0),
            FractionColumnWidth(0.35),
          ),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        textBaseline: TextBaseline.alphabetic,
        border: const TableBorder(),
        children: list,
      ),
    );
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      sliver: BlockSliver(
        title: 'Stats',
        sliver: SliverToBoxAdapter(child: child),
      ),
    );
  }
}

class _AbilitiesSiLiver extends HookWidget {
  final List<Ability> abilities;

  // ignore: unused_element
  const _AbilitiesSiLiver({super.key, required this.abilities});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      sliver: BlockSliver(
        title: 'Abilities',
        sliver: DecoratedSliver(
          decoration: ShapeDecoration(
            color: theme.colorScheme.secondaryContainer,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0))
            ),
          ),
          sliver: SliverPadding(
          padding: const EdgeInsets.all(12.0),
            sliver: SliverList.builder(
              itemBuilder: (context, index) {
                final ability = abilities[index];
                return ListTile(
                  leading: Icon(
                    ability.secret
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  title: Text(
                    ability.name.toTitleCase(),
                    style: theme.textTheme.headlineSmall,
                  ),
                  dense: true,
                );
              },
              itemCount: abilities.length,
            ),
          ),
        ),
      ),
    );
  }
}

class _MovesSiLiver extends HookWidget {
  final List<Move> moves;

  // ignore: unused_element
  const _MovesSiLiver({super.key, required this.moves});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      sliver: BlockSliver(
        title: 'Movements',
        sliver: DecoratedSliver(
          decoration: ShapeDecoration(
            color: theme.colorScheme.secondaryContainer,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0))
            ),
          ),
          sliver: SliverPadding(
            padding: const EdgeInsets.all(12.0),
            sliver: SliverList.builder(
              itemBuilder: (context, index) {
                final move = moves[index];
                return ListTile(
                  leading: Icon(
                    Icons.double_arrow_sharp,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  title: Text(
                    move.name.toTitleCase(),
                    style: theme.textTheme.headlineSmall,
                  ),
                  dense: true,
                );
              },
              itemCount: moves.length,
            ),
          ),
        ),
      ),
    );
  }
}
