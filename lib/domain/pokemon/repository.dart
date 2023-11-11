import 'package:dartz/dartz.dart';
import 'package:pokemon_go/domain/failure.dart';
import 'package:pokemon_go/domain/pokemon/implementation/pokemon_repository_impl.dart';
import 'package:pokemon_go/domain/pokemon/model/pokemon.dart';
import 'package:pokemon_go/domain/pokemon/model/pokemon_shallow.dart';
import 'package:pokemon_go/infrastructure/dio_instance.dart';
import 'package:pokemon_go/infrastructure/poke_api/pokeapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository.g.dart';

@Riverpod(dependencies: [dio], keepAlive: false)
PokemonRepository pokemonRepository(PokemonRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  final pokeApi = PokeApi(dio);
  return PokemonRemoteRepository(pokeApi);
}

abstract interface class PokemonRepository {
  Future<Either<DomainFailure, List<PokemonShallow>>> getPage({
    int offset = 0,
    int limit = 60,
  });

  Future<Either<DomainFailure, Pokemon>> getDetail({required int id});
}
