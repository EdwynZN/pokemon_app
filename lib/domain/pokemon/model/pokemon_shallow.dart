import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_shallow.freezed.dart';
part 'pokemon_shallow.g.dart';

@freezed
class PokemonShallow with _$PokemonShallow {
  const factory PokemonShallow({
    required final String name,
    required final int id,
  }) = _PokemonShallow;
	
  factory PokemonShallow.fromJson(Map<String, dynamic> json) =>
			_$PokemonShallowFromJson(json);
}
