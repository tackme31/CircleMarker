import 'package:circle_marker/models/map_detail.dart';
import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/repositories/map_repository.dart';
import 'package:circle_marker/repositories/image_repository.dart';
import 'package:circle_marker/states/map_list_state.dart';
import 'package:circle_marker/exceptions/app_exceptions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

part 'map_list_view_model.g.dart';

@riverpod
class MapListViewModel extends _$MapListViewModel {
  @override
  Future<MapListState> build() async {
    final maps = await ref.watch(mapRepositoryProvider).getMapDetails();
    return MapListState(maps: maps);
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

      final maps = await ref.read(mapRepositoryProvider).getMapDetails();
      state = AsyncData(MapListState(maps: maps));

      return insertedMap;
    } on ImageOperationException catch (e) {
      debugPrint('Failed to add map: $e');
      rethrow;
    }
  }

  Future<void> refreshMaps() async {
    final maps = await ref.read(mapRepositoryProvider).getMapDetails();
    state = AsyncData(MapListState(maps: maps));
  }

  Future<void> removeMap(int mapId) async {
    await ref.read(mapRepositoryProvider).deleteMapDetail(mapId);
    await ref.read(circleRepositoryProvider).deleteCircles(mapId);

    final maps = await ref.read(mapRepositoryProvider).getMapDetails();
    state = AsyncData(MapListState(maps: maps));
  }
}
