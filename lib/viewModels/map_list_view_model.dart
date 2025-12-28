import 'package:circle_marker/models/map_detail.dart';
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
    final maps = await ref
        .watch(mapRepositoryProvider)
        .getMapDetailsWithCircleCount();
    return MapListState(maps: maps, searchQuery: '', selectedEventNames: []);
  }

  /// マップタイトルで検索
  ///
  /// Repository層のSQL検索を呼び出し、結果でstateを更新
  Future<void> searchMaps(String query) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final currentState = state.value;
      final selectedEventNames = currentState?.selectedEventNames ?? [];

      final maps = await ref
          .read(mapRepositoryProvider)
          .searchMapsWithEventFilter(query, selectedEventNames);

      return MapListState(
        maps: maps,
        searchQuery: query,
        selectedEventNames: selectedEventNames,
      );
    });
  }

  /// 検索をクリア
  void clearSearch() {
    searchMaps('');
  }

  Future<MapDetail> addMapDetail(String imagePath) async {
    try {
      // 1. 仮のMapDetailをDB挿入してmapIdを取得
      const tempMapDetail = MapDetail(
        title: 'New Map',
        eventName: 'New Event',
        baseImagePath: '',
        thumbnailPath: null,
      );
      final insertedMap = await ref
          .read(mapRepositoryProvider)
          .insertMapDetail(tempMapDetail);

      // 2. mapIdを使って画像を保存し、サムネイルを生成
      final imagePaths = await ref
          .read(imageRepositoryProvider.notifier)
          .saveMapImageWithThumbnail(imagePath, mapId: insertedMap.mapId!);

      // 3. 画像パスでMapDetailを更新
      await ref
          .read(mapRepositoryProvider)
          .updateBaseImagePath(
            insertedMap.mapId!,
            imagePaths.original,
            imagePaths.thumbnail,
          );

      // 4. 現在の検索クエリで再検索
      final currentState = state.value;
      await searchMaps(currentState?.searchQuery ?? '');

      // 5. 更新されたMapDetailを返す
      return insertedMap.copyWith(
        baseImagePath: imagePaths.original,
        thumbnailPath: imagePaths.thumbnail,
      );
    } on ImageOperationException catch (e) {
      debugPrint('Failed to add map: $e');
      rethrow;
    }
  }

  Future<void> removeMap(int mapId) async {
    // deleteMapDetail() のトランザクション内でサークルも削除されるため、
    // deleteCircles() の呼び出しは不要
    await ref.read(mapRepositoryProvider).deleteMapDetail(mapId);

    // 現在の検索クエリとフィルター状態で再検索
    final currentState = state.value;
    final searchQuery = currentState?.searchQuery ?? '';
    final selectedEventNames = currentState?.selectedEventNames ?? [];

    state = await AsyncValue.guard(() async {
      final maps = await ref
          .read(mapRepositoryProvider)
          .searchMapsWithEventFilter(searchQuery, selectedEventNames);

      return MapListState(
        maps: maps,
        searchQuery: searchQuery,
        selectedEventNames: selectedEventNames,
      );
    });

    // サークルリストも更新
    ref.invalidate(circleListViewModelProvider);
  }

  Future<void> updateMapImage(int mapId, String newImagePath) async {
    try {
      // ImageRepository で画像を保存し、サムネイルを生成
      final imagePaths = await ref
          .read(imageRepositoryProvider.notifier)
          .saveMapImageWithThumbnail(newImagePath, mapId: mapId);

      await ref
          .read(mapRepositoryProvider)
          .updateBaseImagePath(
            mapId,
            imagePaths.original,
            imagePaths.thumbnail,
          );

      // 現在の検索クエリとフィルター状態で再検索
      final currentState = state.value;
      final searchQuery = currentState?.searchQuery ?? '';
      final selectedEventNames = currentState?.selectedEventNames ?? [];

      state = await AsyncValue.guard(() async {
        final maps = await ref
            .read(mapRepositoryProvider)
            .searchMapsWithEventFilter(searchQuery, selectedEventNames);

        return MapListState(
          maps: maps,
          searchQuery: searchQuery,
          selectedEventNames: selectedEventNames,
        );
      });
    } on ImageOperationException catch (e) {
      debugPrint('Failed to update map image: $e');
      rethrow;
    }
  }

  /// イベント名フィルターを設定
  ///
  /// [eventNames] 選択されたイベント名のリスト（空リスト = 全イベント選択）
  Future<void> setEventFilter(List<String> eventNames) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final currentState = state.value;
      final searchQuery = currentState?.searchQuery ?? '';

      final maps = await ref
          .read(mapRepositoryProvider)
          .searchMapsWithEventFilter(searchQuery, eventNames);

      return MapListState(
        maps: maps,
        searchQuery: searchQuery,
        selectedEventNames: eventNames,
      );
    });
  }

  Future<void> refresh() async {
    final currentState = state.value;
    final searchQuery = currentState?.searchQuery ?? '';
    final selectedEventNames = currentState?.selectedEventNames ?? [];

    state = await AsyncValue.guard(() async {
      final maps = await ref
          .read(mapRepositoryProvider)
          .searchMapsWithEventFilter(searchQuery, selectedEventNames);

      return MapListState(
        maps: maps,
        searchQuery: searchQuery,
        selectedEventNames: selectedEventNames,
      );
    });
  }

  /// イベント名フィルターをクリア
  void clearEventFilter() {
    setEventFilter([]);
  }
}
