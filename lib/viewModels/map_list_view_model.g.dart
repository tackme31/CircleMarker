// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mapListViewModelHash() => r'6f57389a65ff582f90a64c724f1dac0c6f25f8f2';

/// See also [MapListViewModel].
@ProviderFor(MapListViewModel)
final mapListViewModelProvider =
    AutoDisposeAsyncNotifierProvider<MapListViewModel, MapListState>.internal(
      MapListViewModel.new,
      name: r'mapListViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mapListViewModelHash,
      dependencies: <ProviderOrFamily>[mapRepositoryProvider],
      allTransitiveDependencies: <ProviderOrFamily>{
        mapRepositoryProvider,
        ...?mapRepositoryProvider.allTransitiveDependencies,
      },
    );

typedef _$MapListViewModel = AutoDisposeAsyncNotifier<MapListState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
