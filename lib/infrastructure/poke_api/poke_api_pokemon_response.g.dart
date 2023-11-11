// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poke_api_pokemon_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PokeApiWrapperResponseImpl _$$PokeApiWrapperResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PokeApiWrapperResponseImpl(
      results: (json['results'] as List<dynamic>)
          .map((e) => PokeApiListValue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PokeApiWrapperResponseImplToJson(
        _$PokeApiWrapperResponseImpl instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

_$PokeApiListValueImpl _$$PokeApiListValueImplFromJson(
        Map<String, dynamic> json) =>
    _$PokeApiListValueImpl(
      name: json['name'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$$PokeApiListValueImplToJson(
        _$PokeApiListValueImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };

_$PokeApiPokemonResponseImpl _$$PokeApiPokemonResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PokeApiPokemonResponseImpl(
      id: json['id'] as int,
      name: json['name'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      baseExperience: json['base_experience'] as int,
      sprites: PokeApiSprite.fromJson(json['sprites'] as Map<String, dynamic>),
      moves: (json['moves'] as List<dynamic>)
          .map((e) => PokeApiMove.fromJson(e as Map<String, dynamic>))
          .toList(),
      types: (json['types'] as List<dynamic>)
          .map((e) => PokeApiType.fromJson(e as Map<String, dynamic>))
          .toList(),
      abilities: (json['abilities'] as List<dynamic>)
          .map((e) => PokeApiAbility.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: (json['stats'] as List<dynamic>)
          .map((e) => PokeApiStat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PokeApiPokemonResponseImplToJson(
        _$PokeApiPokemonResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'height': instance.height,
      'weight': instance.weight,
      'base_experience': instance.baseExperience,
      'sprites': instance.sprites,
      'moves': instance.moves,
      'types': instance.types,
      'abilities': instance.abilities,
      'stats': instance.stats,
    };

_$PokeApiSpriteImpl _$$PokeApiSpriteImplFromJson(Map<String, dynamic> json) =>
    _$PokeApiSpriteImpl(
      back: json['back_default'] as String,
      backFemale: json['back_female'] as String?,
      backShiny: json['back_shiny'] as String?,
      backShinyFemale: json['back_shiny_female'] as String?,
      front: json['front_default'] as String,
      frontFemale: json['front_female'] as String?,
      frontShiny: json['front_shiny'] as String?,
      frontShinyFemale: json['front_shiny_female'] as String?,
    );

Map<String, dynamic> _$$PokeApiSpriteImplToJson(_$PokeApiSpriteImpl instance) =>
    <String, dynamic>{
      'back_default': instance.back,
      'back_female': instance.backFemale,
      'back_shiny': instance.backShiny,
      'back_shiny_female': instance.backShinyFemale,
      'front_default': instance.front,
      'front_female': instance.frontFemale,
      'front_shiny': instance.frontShiny,
      'front_shiny_female': instance.frontShinyFemale,
    };

_$PokeApiMoveImpl _$$PokeApiMoveImplFromJson(Map<String, dynamic> json) =>
    _$PokeApiMoveImpl(
      move: PokeApiNameWrapper.fromJson(json['move'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PokeApiMoveImplToJson(_$PokeApiMoveImpl instance) =>
    <String, dynamic>{
      'move': instance.move,
    };

_$PokeApiAbilityImpl _$$PokeApiAbilityImplFromJson(Map<String, dynamic> json) =>
    _$PokeApiAbilityImpl(
      ability:
          PokeApiNameWrapper.fromJson(json['ability'] as Map<String, dynamic>),
      isHidden: json['is_hidden'] as bool,
    );

Map<String, dynamic> _$$PokeApiAbilityImplToJson(
        _$PokeApiAbilityImpl instance) =>
    <String, dynamic>{
      'ability': instance.ability,
      'is_hidden': instance.isHidden,
    };

_$PokeApiTypeImpl _$$PokeApiTypeImplFromJson(Map<String, dynamic> json) =>
    _$PokeApiTypeImpl(
      type: PokeApiNameWrapper.fromJson(json['type'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PokeApiTypeImplToJson(_$PokeApiTypeImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
    };

_$PokeApiStatImpl _$$PokeApiStatImplFromJson(Map<String, dynamic> json) =>
    _$PokeApiStatImpl(
      stat: PokeApiNameWrapper.fromJson(json['stat'] as Map<String, dynamic>),
      baseStat: json['base_stat'] as int,
    );

Map<String, dynamic> _$$PokeApiStatImplToJson(_$PokeApiStatImpl instance) =>
    <String, dynamic>{
      'stat': instance.stat,
      'base_stat': instance.baseStat,
    };

_$PokeApiNameWrapperImpl _$$PokeApiNameWrapperImplFromJson(
        Map<String, dynamic> json) =>
    _$PokeApiNameWrapperImpl(
      name: json['name'] as String,
    );

Map<String, dynamic> _$$PokeApiNameWrapperImplToJson(
        _$PokeApiNameWrapperImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
    };
