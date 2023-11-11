// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pokemonDetailsHash() => r'f3898552748f2f140ea03451414c1d44311bc131';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [pokemonDetails].
@ProviderFor(pokemonDetails)
const pokemonDetailsProvider = PokemonDetailsFamily();

/// See also [pokemonDetails].
class PokemonDetailsFamily extends Family<AsyncValue<Pokemon>> {
  /// See also [pokemonDetails].
  const PokemonDetailsFamily();

  /// See also [pokemonDetails].
  PokemonDetailsProvider call({
    required int id,
  }) {
    return PokemonDetailsProvider(
      id: id,
    );
  }

  @override
  PokemonDetailsProvider getProviderOverride(
    covariant PokemonDetailsProvider provider,
  ) {
    return call(
      id: provider.id,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    pokemonRepositoryProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    pokemonRepositoryProvider,
    ...?pokemonRepositoryProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'pokemonDetailsProvider';
}

/// See also [pokemonDetails].
class PokemonDetailsProvider extends AutoDisposeFutureProvider<Pokemon> {
  /// See also [pokemonDetails].
  PokemonDetailsProvider({
    required int id,
  }) : this._internal(
          (ref) => pokemonDetails(
            ref as PokemonDetailsRef,
            id: id,
          ),
          from: pokemonDetailsProvider,
          name: r'pokemonDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pokemonDetailsHash,
          dependencies: PokemonDetailsFamily._dependencies,
          allTransitiveDependencies:
              PokemonDetailsFamily._allTransitiveDependencies,
          id: id,
        );

  PokemonDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Pokemon> Function(PokemonDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PokemonDetailsProvider._internal(
        (ref) => create(ref as PokemonDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Pokemon> createElement() {
    return _PokemonDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PokemonDetailsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PokemonDetailsRef on AutoDisposeFutureProviderRef<Pokemon> {
  /// The parameter `id` of this provider.
  int get id;
}

class _PokemonDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Pokemon> with PokemonDetailsRef {
  _PokemonDetailsProviderElement(super.provider);

  @override
  int get id => (origin as PokemonDetailsProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
