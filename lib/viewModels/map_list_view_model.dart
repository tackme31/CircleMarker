import 'package:circle_marker/models/map_detail.dart';
import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/repositories/map_repository.dart';
import 'package:circle_marker/repositories/image_repository.dart';
import 'package:circle_marker/states/map_list_state.dart';
import 'package:circle_marker/exceptions/app_exceptions.dart';
import 'package:circle_marker/viewModels/circle_list_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

part 'map_list_view_model.g.dart';

@riverpod
class MapListViewModel extends _$MapListViewModel {
  @override
  Future<MapListState> build() async {
    final maps = await ref.watch(mapRepositoryProvider).getMapDetails();
    return MapListState(maps: maps, searchQuery: '');
  }

  /// マップタイトルで検索
  ///
  /// Repository層のSQL検索を呼び出し、結果でstateを更新
  Future<void> searchMaps(String query) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final maps = await ref
          .read(mapRepositoryProvider)
          .searchMapsByTitle(query);

      return MapListState(maps: maps, searchQuery: query);
    });
  }

  /// 検索をクリア
  void clearSearch() {
    searchMaps('');
  }

  Future<MapDetail> addMapDetail(String imagePath) async {
    try {
      // ImageRepository で画像を保存し、サムネイルを生成
      final imagePaths = await ref
          .read(imageRepositoryProvider.notifier)
          .saveMapImageWithThumbnail(imagePath);

      final mapDetail = MapDetail(
        title: 'New Map',
        baseImagePath: imagePaths.original,
        thumbnailPath: imagePaths.thumbnail,
      );
      final insertedMap = await ref
          .read(mapRepositoryProvider)
          .insertMapDetail(mapDetail);

      // 現在の検索クエリで再検索
      final currentState = state.value;
      await searchMaps(currentState?.searchQuery ?? '');

      return insertedMap;
    } on ImageOperationException catch (e) {
      debugPrint('Failed to add map: $e');
      rethrow;
    }
  }

  Future<void> removeMap(int mapId) async {
    await ref.read(mapRepositoryProvider).deleteMapDetail(mapId);
    await ref.read(circleRepositoryProvider).deleteCircles(mapId);

    // 現在の検索クエリで再検索
    final currentState = state.value;
    await searchMaps(currentState?.searchQuery ?? '');

    // サークルリストも更新
    ref.invalidate(circleListViewModelProvider);
  }

  Future<void> updateMapImage(int mapId, String newImagePath) async {
    try {
      // ImageRepository で画像を保存し、サムネイルを生成
      final imagePaths = await ref
          .read(imageRepositoryProvider.notifier)
          .saveMapImageWithThumbnail(newImagePath);

      await ref
          .read(mapRepositoryProvider)
          .updateBaseImagePath(
            mapId,
            imagePaths.original,
            imagePaths.thumbnail,
          );

      // 現在の検索クエリで再検索
      final currentState = state.value;
      await searchMaps(currentState?.searchQuery ?? '');
    } on ImageOperationException catch (e) {
      debugPrint('Failed to update map image: $e');
      rethrow;
    }
  }
}
