// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mapListViewModelHash() => r'351b7722b75483c00c6fd4fc0757c4b9a8ee7d9e';

/// See also [MapListViewModel].
@ProviderFor(MapListViewModel)
final mapListViewModelProvider =
    AutoDisposeAsyncNotifierProvider<MapListViewModel, MapListState>.internal(
      MapListViewModel.new,
      name: r'mapListViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mapListViewModelHash,
      dependencies: <ProviderOrFamily>[
        mapRepositoryProvider,
        circleRepositoryProvider,
      ],
      allTransitiveDependencies: <ProviderOrFamily>{
        mapRepositoryProvider,
        ...?mapRepositoryProvider.allTransitiveDependencies,
        circleRepositoryProvider,
        ...?circleRepositoryProvider.allTransitiveDependencies,
      },
    );

typedef _$MapListViewModel = AutoDisposeAsyncNotifier<MapListState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
