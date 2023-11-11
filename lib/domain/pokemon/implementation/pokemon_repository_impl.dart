import 'package:dartz/dartz.dart';
import 'package:pokemon_go/domain/failure.dart';
import 'package:pokemon_go/domain/pokemon/model/pokemon.dart';
import 'package:pokemon_go/domain/pokemon/model/pokemon_shallow.dart';
import 'package:pokemon_go/domain/pokemon/repository.dart';
import 'package:pokemon_go/infrastructure/poke_api/pokeapi.dart';

final class PokemonRemoteRepository implements PokemonRepository {
  final PokeApi api;

  const PokemonRemoteRepository(this.api);

  @override
  Future<Either<DomainFailure, Pokemon>> getDetail({required int id}) async {
    final response = await api.getPokemonDetail(id);
    return Right(response.toDomain());
  }

  @override
  Future<Either<DomainFailure, List<PokemonShallow>>> getPage({
    int offset = 0,
    int limit = 60,
  }) async {
    final response = await api.getPokemons({
      'offset': offset,
      'limit': limit,
    });
    final List<PokemonShallow> pokemons = [];
    final RegExp regExp = RegExp(r'/\d*/$');
    for (final p in response.results) {
      final name = p.name;
      final match = regExp.stringMatch(p.url);
      int? id;
      if (match != null) {
        id = int.tryParse(match.substring(1, match.length - 1));
      }
      if (id == null) {
        return Left(ItemFailure(message: 'No ID', name: name));
      }
      pokemons.add(PokemonShallow(name: name, id: id));
    }
    return Right(pokemons);
  }
}
