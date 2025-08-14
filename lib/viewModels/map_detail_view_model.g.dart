// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_detail_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mapDetailViewModelHash() =>
    r'9b083a2a267007f063cd288e898a6afd4bd21a5c';

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

abstract class _$MapDetailViewModel
    extends BuildlessAutoDisposeAsyncNotifier<MapDetailState> {
  late final int mapId;

  FutureOr<MapDetailState> build(int mapId);
}

/// See also [MapDetailViewModel].
@ProviderFor(MapDetailViewModel)
const mapDetailViewModelProvider = MapDetailViewModelFamily();

/// See also [MapDetailViewModel].
class MapDetailViewModelFamily extends Family<AsyncValue<MapDetailState>> {
  /// See also [MapDetailViewModel].
  const MapDetailViewModelFamily();

  /// See also [MapDetailViewModel].
  MapDetailViewModelProvider call(int mapId) {
    return MapDetailViewModelProvider(mapId);
  }

  @override
  MapDetailViewModelProvider getProviderOverride(
    covariant MapDetailViewModelProvider provider,
  ) {
    return call(provider.mapId);
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    mapRepositoryProvider,
    circleRepositoryProvider,
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
        mapRepositoryProvider,
        ...?mapRepositoryProvider.allTransitiveDependencies,
        circleRepositoryProvider,
        ...?circleRepositoryProvider.allTransitiveDependencies,
      };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mapDetailViewModelProvider';
}

/// See also [MapDetailViewModel].
class MapDetailViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          MapDetailViewModel,
          MapDetailState
        > {
  /// See also [MapDetailViewModel].
  MapDetailViewModelProvider(int mapId)
    : this._internal(
        () => MapDetailViewModel()..mapId = mapId,
        from: mapDetailViewModelProvider,
        name: r'mapDetailViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$mapDetailViewModelHash,
        dependencies: MapDetailViewModelFamily._dependencies,
        allTransitiveDependencies:
            MapDetailViewModelFamily._allTransitiveDependencies,
        mapId: mapId,
      );

  MapDetailViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mapId,
  }) : super.internal();

  final int mapId;

  @override
  FutureOr<MapDetailState> runNotifierBuild(
    covariant MapDetailViewModel notifier,
  ) {
    return notifier.build(mapId);
  }

  @override
  Override overrideWith(MapDetailViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: MapDetailViewModelProvider._internal(
        () => create()..mapId = mapId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mapId: mapId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MapDetailViewModel, MapDetailState>
  createElement() {
    return _MapDetailViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MapDetailViewModelProvider && other.mapId == mapId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mapId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MapDetailViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<MapDetailState> {
  /// The parameter `mapId` of this provider.
  int get mapId;
}

class _MapDetailViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          MapDetailViewModel,
          MapDetailState
        >
    with MapDetailViewModelRef {
  _MapDetailViewModelProviderElement(super.provider);

  @override
  int get mapId => (origin as MapDetailViewModelProvider).mapId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
