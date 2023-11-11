// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PokemonImpl _$$PokemonImplFromJson(Map<String, dynamic> json) =>
    _$PokemonImpl(
      id: json['id'] as int,
      name: json['name'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      baseExperience: json['baseExperience'] as int,
      sprite: Sprite.fromJson(json['sprite'] as Map<String, dynamic>),
      femaleSprite: json['femaleSprite'] == null
          ? null
          : Sprite.fromJson(json['femaleSprite'] as Map<String, dynamic>),
      shinySprite: json['shinySprite'] == null
          ? null
          : Sprite.fromJson(json['shinySprite'] as Map<String, dynamic>),
      shinyFemaleSprite: json['shinyFemaleSprite'] == null
          ? null
          : Sprite.fromJson(json['shinyFemaleSprite'] as Map<String, dynamic>),
      abilities: (json['abilities'] as List<dynamic>?)
              ?.map((e) => Ability.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      movements: (json['movements'] as List<dynamic>?)
              ?.map((e) => Move.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      stats: (json['stats'] as List<dynamic>?)
              ?.map((e) => Stat.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      types: (json['types'] as List<dynamic>?)
              ?.map((e) => PokemonType.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PokemonImplToJson(_$PokemonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'height': instance.height,
      'weight': instance.weight,
      'baseExperience': instance.baseExperience,
      'sprite': instance.sprite,
      'femaleSprite': instance.femaleSprite,
      'shinySprite': instance.shinySprite,
      'shinyFemaleSprite': instance.shinyFemaleSprite,
      'abilities': instance.abilities,
      'movements': instance.movements,
      'stats': instance.stats,
      'types': instance.types,
    };

_$MoveImpl _$$MoveImplFromJson(Map<String, dynamic> json) => _$MoveImpl(
      name: json['name'] as String,
    );

Map<String, dynamic> _$$MoveImplToJson(_$MoveImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

_$StatImpl _$$StatImplFromJson(Map<String, dynamic> json) => _$StatImpl(
      name: json['name'] as String,
      value: json['value'] as int,
    );

Map<String, dynamic> _$$StatImplToJson(_$StatImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };

_$PokemonTypeImpl _$$PokemonTypeImplFromJson(Map<String, dynamic> json) =>
    _$PokemonTypeImpl(
      name: json['name'] as String,
    );

Map<String, dynamic> _$$PokemonTypeImplToJson(_$PokemonTypeImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

_$AbilityImpl _$$AbilityImplFromJson(Map<String, dynamic> json) =>
    _$AbilityImpl(
      name: json['name'] as String,
      secret: json['secret'] as bool,
    );

Map<String, dynamic> _$$AbilityImplToJson(_$AbilityImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'secret': instance.secret,
    };
