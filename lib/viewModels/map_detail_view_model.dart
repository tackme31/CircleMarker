import 'dart:io';

import 'package:circle_marker/models/circle_detail.dart';
import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/repositories/map_repository.dart';
import 'package:circle_marker/repositories/image_repository.dart';
import 'package:circle_marker/states/map_detail_state.dart';
import 'package:circle_marker/exceptions/app_exceptions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

part 'map_detail_view_model.g.dart';

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
      circleName: '',
      spaceNo: '',
      imagePath: null,
      note: null,
      description: null,
    );
    final insertedCircle = await ref
        .read(circleRepositoryProvider)
        .insertCircleDetail(circleDetail);

    final circles = await ref
        .read(circleRepositoryProvider)
        .getCircles(circleDetail.mapId!);
    state = AsyncData(state.value!.copyWith(circles: circles));

    return insertedCircle;
  }

  Future<void> removeCircle(int circleId) async {
    await ref.read(circleRepositoryProvider).deleteCircle(circleId);

    final circles = await ref
        .read(circleRepositoryProvider)
        .getCircles(state.value!.mapDetail.mapId!);
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateMapTile(String title) async {
    final updatedMap = state.value!.mapDetail.copyWith(title: title);
    final result = await ref
        .read(mapRepositoryProvider)
        .updateMapDetail(updatedMap);

    state = AsyncData(state.value!.copyWith(mapDetail: result));
  }

  Future<void> updateCirclePosition(
    int circleId,
    int positionX,
    int positionY,
  ) async {
    await ref
        .read(circleRepositoryProvider)
        .updatePosition(circleId, positionX, positionY);

    final circles = await ref
        .read(circleRepositoryProvider)
        .getCircles(state.value!.mapDetail.mapId!);
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateCirclePointer(
    int circleId,
    int pointerX,
    int pointerY,
  ) async {
    await ref
        .read(circleRepositoryProvider)
        .updatePointer(circleId, pointerX, pointerY);

    final circles = await ref
        .read(circleRepositoryProvider)
        .getCircles(state.value!.mapDetail.mapId!);
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateCircleName(int circleId, String circleName) async {
    await ref
        .read(circleRepositoryProvider)
        .updateCircleName(circleId, circleName);

    final circles = await ref
        .read(circleRepositoryProvider)
        .getCircles(state.value!.mapDetail.mapId!);
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateCircleSpaceNo(int circleId, String spaceNo) async {
    await ref.read(circleRepositoryProvider).updateSpaceNo(circleId, spaceNo);

    final circles = await ref
        .read(circleRepositoryProvider)
        .getCircles(state.value!.mapDetail.mapId!);
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateCircleNote(int circleId, String note) async {
    await ref.read(circleRepositoryProvider).updateNote(circleId, note);

    final circles = await ref
        .read(circleRepositoryProvider)
        .getCircles(state.value!.mapDetail.mapId!);
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateCircleDescription(int circleId, String description) async {
    await ref
        .read(circleRepositoryProvider)
        .updateDescription(circleId, description);

    final circles = await ref
        .read(circleRepositoryProvider)
        .getCircles(state.value!.mapDetail.mapId!);
    state = AsyncData(state.value!.copyWith(circles: circles));
  }

  Future<void> updateCircleImage(int circleId, String imagePath) async {
    try {
      // ImageRepository で画像を圧縮保存
      final compressedPath = await ref
          .read(imageRepositoryProvider.notifier)
          .saveCircleImage(imagePath);

      await ref
          .read(circleRepositoryProvider)
          .updateImagePath(circleId, compressedPath);

      final circles = await ref
          .read(circleRepositoryProvider)
          .getCircles(state.value!.mapDetail.mapId!);
      state = AsyncData(state.value!.copyWith(circles: circles));
    } on ImageOperationException catch (e) {
      debugPrint('Failed to update circle image: $e');
      rethrow;
    }
  }

  Future<void> updateCircleMenuImage(int circleId, String menuImagePath) async {
    try {
      // ImageRepository で画像を圧縮保存
      final compressedPath = await ref
          .read(imageRepositoryProvider.notifier)
          .saveCircleImage(menuImagePath);

      await ref
          .read(circleRepositoryProvider)
          .updateMenuImagePath(circleId, compressedPath);

      final circles = await ref
          .read(circleRepositoryProvider)
          .getCircles(state.value!.mapDetail.mapId!);
      state = AsyncData(state.value!.copyWith(circles: circles));
    } on ImageOperationException catch (e) {
      debugPrint('Failed to update menu image: $e');
      rethrow;
    }
  }

  Future<void> updateIsDone(int circleId, bool isDone) async {
    await ref.read(circleRepositoryProvider).updateIsDone(circleId, isDone);

    final circles = await ref
        .read(circleRepositoryProvider)
        .getCircles(state.value!.mapDetail.mapId!);
    state = AsyncData(state.value!.copyWith(circles: circles));
  }
}
