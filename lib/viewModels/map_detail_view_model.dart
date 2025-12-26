import 'dart:io';

import 'package:circle_marker/models/circle_detail.dart';
import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/repositories/map_repository.dart';
import 'package:circle_marker/states/map_detail_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

part 'map_detail_view_model.g.dart';

/// マップ詳細画面の状態とビジネスロジックを管理する ViewModel
///
/// このクラスは以下の責務を持つ:
/// - マップとサークル ID リストの読み込み
/// - サークルの追加・削除
/// - マップ情報の更新
///
/// ## 状態管理
/// - [MapDetailState] を通じてマップと ID リストを保持
/// - 個別サークルは [CircleViewModel] で管理（Riverpod Family パターン）
@riverpod
class MapDetailViewModel extends _$MapDetailViewModel {
  @override
  Future<MapDetailState> build(int mapId) async {
    final mapRepository = ref.watch(mapRepositoryProvider);
    final circleRepository = ref.watch(circleRepositoryProvider);

    final map = await mapRepository.getMapDetail(mapId);
    final circles = await circleRepository.getCircles(mapId);

    final file = File(map.baseImagePath!);
    final decoded = await decodeImageFromList(await file.readAsBytes());
    final baseImageSize = Size(
      decoded.width.toDouble(),
      decoded.height.toDouble(),
    );

    return MapDetailState(
      mapDetail: map,
      baseImage: file,
      baseImageSize: baseImageSize,
      circleIds: circles.map((c) => c.circleId!).toList(),
    );
  }

  /// 新規サークルを追加する
  ///
  /// [mapId] マップ ID
  /// [positionX] 画像座標系での X 位置
  /// [positionY] 画像座標系での Y 位置
  /// [sizeHeight] サークルの高さ
  /// [sizeWidth] サークルの幅
  ///
  /// ## Returns
  /// 追加されたサークルの詳細
  Future<CircleDetail> addCircleDetail(
    int mapId,
    int positionX,
    int positionY,
    int sizeHeight,
    int sizeWidth,
  ) async {
    final circleDetail = CircleDetail(
      mapId: mapId,
      positionX: positionX,
      positionY: positionY,
      sizeHeight: sizeHeight,
      sizeWidth: sizeWidth,
      pointerX: positionX + sizeWidth + 50,
      pointerY: positionY + sizeHeight ~/ 2,
      circleName: '',
      spaceNo: '',
      imagePath: null,
      note: null,
      description: null,
    );
    final insertedCircle = await ref
        .read(circleRepositoryProvider)
        .insertCircleDetail(circleDetail);

    // ID リストに追加
    final currentState = await future;
    state = AsyncData(
      currentState.copyWith(
        circleIds: [...currentState.circleIds, insertedCircle.circleId!],
      ),
    );

    return insertedCircle;
  }

  /// サークルを削除する
  ///
  /// [circleId] 削除するサークルの ID
  Future<void> removeCircle(int circleId) async {
    await ref.read(circleRepositoryProvider).deleteCircle(circleId);

    // ID リストから削除
    final currentState = await future;
    state = AsyncData(
      currentState.copyWith(
        circleIds: currentState.circleIds.where((id) => id != circleId).toList(),
      ),
    );
  }

  /// マップタイトルを更新する
  ///
  /// [title] 新しいタイトル
  Future<void> updateMapTile(String title) async {
    final updatedMap = state.value!.mapDetail.copyWith(title: title);
    final result = await ref
        .read(mapRepositoryProvider)
        .updateMapDetail(updatedMap);

    state = AsyncData(state.value!.copyWith(mapDetail: result));
  }
}
