import 'dart:io';

import 'package:circle_marker/models/circle_detail.dart';
import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/repositories/map_repository.dart';
import 'package:circle_marker/states/map_detail_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

part 'map_detail_view_model.g.dart';

@Riverpod(dependencies: [mapRepository, circleRepository])
class MapDetailViewModel extends _$MapDetailViewModel {
  late final MapRepository _mapRepository;
  late final CircleRepository _circleRepository;

  @override
  Future<MapDetailState> build(int mapId) async {
    _mapRepository = ref.watch(mapRepositoryProvider);
    _circleRepository = ref.watch(circleRepositoryProvider);

    final map = await _mapRepository.getMapDetail(mapId);
    final circles = await _circleRepository.getCircles(mapId);

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
      circles: circles,
    );
  }

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
      circleName: 'New Circle',
      spaceNo: 'X-99a',
      imagePath: null,
      note: null,
      description: null,
    );
    final insertedCircle = await _circleRepository.insertCircleDetail(
      circleDetail,
    );

    // 追加後に最新のリストを取得して状態更新
    final circles = await _circleRepository.getCircles(circleDetail.mapId!);
    state = AsyncData(state.value!.copyWith(circles: circles));

    return insertedCircle;
  }

  Future<void> removeCircle(int circleId) async {
    await _circleRepository.deleteCircle(circleId);

    // 削除後に最新のリストを取得して状態更新
    final circles = await _circleRepository.getCircles(
      state.value!.mapDetail.mapId!,
    );
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateMapTile(String title) async {
    final updatedMap = state.value!.mapDetail.copyWith(title: title);
    final result = await _mapRepository.updateMapDetail(updatedMap);

    // 更新後に状態を更新
    state = AsyncData(state.value!.copyWith(mapDetail: result));
  }

  Future<void> updateCirclePosition(
    int circleId,
    int positionX,
    int positionY,
  ) async {
    await _circleRepository.updatePosition(circleId, positionX, positionY);

    // 更新後に最新のリストを取得して状態更新
    final circles = await _circleRepository.getCircles(
      state.value!.mapDetail.mapId!,
    );
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateCirclePointer(
    int circleId,
    int pointerX,
    int pointerY,
  ) async {
    await _circleRepository.updatePointer(circleId, pointerX, pointerY);

    // 更新後に最新のリストを取得して状態更新
    final circles = await _circleRepository.getCircles(
      state.value!.mapDetail.mapId!,
    );
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateCircleName(int circleId, String circleName) async {
    await _circleRepository.updateCircleName(circleId, circleName);

    // 更新後に最新のリストを取得して状態更新
    final circles = await _circleRepository.getCircles(
      state.value!.mapDetail.mapId!,
    );
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateCircleSpaceNo(int circleId, String spaceNo) async {
    await _circleRepository.updateSpaceNo(circleId, spaceNo);

    // 更新後に最新のリストを取得して状態更新
    final circles = await _circleRepository.getCircles(
      state.value!.mapDetail.mapId!,
    );
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateCircleNote(int circleId, String note) async {
    await _circleRepository.updateNote(circleId, note);

    // 更新後に最新のリストを取得して状態更新
    final circles = await _circleRepository.getCircles(
      state.value!.mapDetail.mapId!,
    );
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateCircleDescription(int circleId, String description) async {
    await _circleRepository.updateSpaceNo(circleId, description);

    // 更新後に最新のリストを取得して状態更新
    final circles = await _circleRepository.getCircles(
      state.value!.mapDetail.mapId!,
    );
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateCircleImage(int circleId, String imagePath) async {
    await _circleRepository.updateImagePath(circleId, imagePath);

    // 更新後に最新のリストを取得して状態更新
    final circles = await _circleRepository.getCircles(
      state.value!.mapDetail.mapId!,
    );
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateCircleMenuImage(
    int circleId,
    String menuImagePath,
  ) async {
    await _circleRepository.updateMenuImagePath(circleId, menuImagePath);

    // 更新後に最新のリストを取得して状態更新
    final circles = await _circleRepository.getCircles(
      state.value!.mapDetail.mapId!,
    );
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateIsDone(int circleId, bool isDone) async {
    await _circleRepository.updateIsDone(circleId, isDone);

    // 更新後に最新のリストを取得して状態更新
    final circles = await _circleRepository.getCircles(
      state.value!.mapDetail.mapId!,
    );
    state = AsyncData(state.value!.copyWith(circles: circles));
  }
}
