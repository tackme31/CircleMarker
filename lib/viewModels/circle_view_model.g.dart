// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$circleViewModelHash() => r'9d89f7d532cdddb0d970d0f74c0e7f307f38b82f';

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

abstract class _$CircleViewModel
    extends BuildlessAutoDisposeAsyncNotifier<CircleDetail> {
  late final int circleId;

  FutureOr<CircleDetail> build(int circleId);
}

/// 個別サークルの状態とビジネスロジックを管理する ViewModel
///
/// Riverpod Family パターンを使用して、各サークルを独立して管理することで
/// パフォーマンスを最適化します。1つのサークル更新時に全サークルが再描画されることを防ぎます。
///
/// Copied from [CircleViewModel].
@ProviderFor(CircleViewModel)
const circleViewModelProvider = CircleViewModelFamily();

/// 個別サークルの状態とビジネスロジックを管理する ViewModel
///
/// Riverpod Family パターンを使用して、各サークルを独立して管理することで
/// パフォーマンスを最適化します。1つのサークル更新時に全サークルが再描画されることを防ぎます。
///
/// Copied from [CircleViewModel].
class CircleViewModelFamily extends Family<AsyncValue<CircleDetail>> {
  /// 個別サークルの状態とビジネスロジックを管理する ViewModel
  ///
  /// Riverpod Family パターンを使用して、各サークルを独立して管理することで
  /// パフォーマンスを最適化します。1つのサークル更新時に全サークルが再描画されることを防ぎます。
  ///
  /// Copied from [CircleViewModel].
  const CircleViewModelFamily();

  /// 個別サークルの状態とビジネスロジックを管理する ViewModel
  ///
  /// Riverpod Family パターンを使用して、各サークルを独立して管理することで
  /// パフォーマンスを最適化します。1つのサークル更新時に全サークルが再描画されることを防ぎます。
  ///
  /// Copied from [CircleViewModel].
  CircleViewModelProvider call(int circleId) {
    return CircleViewModelProvider(circleId);
  }

  @override
  CircleViewModelProvider getProviderOverride(
    covariant CircleViewModelProvider provider,
  ) {
    return call(provider.circleId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'circleViewModelProvider';
}

/// 個別サークルの状態とビジネスロジックを管理する ViewModel
///
/// Riverpod Family パターンを使用して、各サークルを独立して管理することで
/// パフォーマンスを最適化します。1つのサークル更新時に全サークルが再描画されることを防ぎます。
///
/// Copied from [CircleViewModel].
class CircleViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<CircleViewModel, CircleDetail> {
  /// 個別サークルの状態とビジネスロジックを管理する ViewModel
  ///
  /// Riverpod Family パターンを使用して、各サークルを独立して管理することで
  /// パフォーマンスを最適化します。1つのサークル更新時に全サークルが再描画されることを防ぎます。
  ///
  /// Copied from [CircleViewModel].
  CircleViewModelProvider(int circleId)
    : this._internal(
        () => CircleViewModel()..circleId = circleId,
        from: circleViewModelProvider,
        name: r'circleViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$circleViewModelHash,
        dependencies: CircleViewModelFamily._dependencies,
        allTransitiveDependencies:
            CircleViewModelFamily._allTransitiveDependencies,
        circleId: circleId,
      );

  CircleViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.circleId,
  }) : super.internal();

  final int circleId;

  @override
  FutureOr<CircleDetail> runNotifierBuild(covariant CircleViewModel notifier) {
    return notifier.build(circleId);
  }

  @override
  Override overrideWith(CircleViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: CircleViewModelProvider._internal(
        () => create()..circleId = circleId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        circleId: circleId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CircleViewModel, CircleDetail>
  createElement() {
    return _CircleViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CircleViewModelProvider && other.circleId == circleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, circleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CircleViewModelRef on AutoDisposeAsyncNotifierProviderRef<CircleDetail> {
  /// The parameter `circleId` of this provider.
  int get circleId;
}

class _CircleViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<CircleViewModel, CircleDetail>
    with CircleViewModelRef {
  _CircleViewModelProviderElement(super.provider);

  @override
  int get circleId => (origin as CircleViewModelProvider).circleId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
