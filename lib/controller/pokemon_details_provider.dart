import 'package:pokemon_go/domain/pokemon/model/pokemon.dart';
import 'package:pokemon_go/domain/pokemon/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_details_provider.g.dart';

@Riverpod(keepAlive: false, dependencies: [pokemonRepository])
Future<Pokemon> pokemonDetails(
  PokemonDetailsRef ref, {
  required int id,
}) async {
  final repository = ref.watch(pokemonRepositoryProvider);
  final fpPokemon = await repository.getDetail(id: id);
  final pokemon = fpPokemon.fold(
    (l) => throw l,
    (r) => r,
  );

  ref.keepAlive();

  return pokemon;
}
