import 'package:circle_marker/exceptions/app_exceptions.dart';
import 'package:circle_marker/models/circle_detail.dart';
import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/repositories/image_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'circle_view_model.g.dart';

/// 個別サークルの状態とビジネスロジックを管理する ViewModel
///
/// Riverpod Family パターンを使用して、各サークルを独立して管理することで
/// パフォーマンスを最適化します。1つのサークル更新時に全サークルが再描画されることを防ぎます。
@riverpod
class CircleViewModel extends _$CircleViewModel {
  @override
  Future<CircleDetail> build(int circleId) async {
    final circleRepository = ref.watch(circleRepositoryProvider);
    return circleRepository.getCircle(circleId);
  }

  /// サークル名を更新 (このサークルのみ再描画)
  Future<void> updateName(String newName) async {
    final circle = await future;
    await ref
        .read(circleRepositoryProvider)
        .updateCircleName(circle.circleId!, newName);
    ref.invalidateSelf();
  }

  /// スペース番号を更新
  Future<void> updateSpaceNo(String spaceNo) async {
    final circle = await future;
    await ref
        .read(circleRepositoryProvider)
        .updateSpaceNo(circle.circleId!, spaceNo);
    ref.invalidateSelf();
  }

  /// ノートを更新
  Future<void> updateNote(String note) async {
    final circle = await future;
    await ref.read(circleRepositoryProvider).updateNote(circle.circleId!, note);
    ref.invalidateSelf();
  }

  /// 説明を更新
  Future<void> updateDescription(String description) async {
    final circle = await future;
    await ref
        .read(circleRepositoryProvider)
        .updateDescription(circle.circleId!, description);
    ref.invalidateSelf();
  }

  /// 位置を更新
  Future<void> updatePosition(int positionX, int positionY) async {
    final circle = await future;
    await ref
        .read(circleRepositoryProvider)
        .updatePosition(circle.circleId!, positionX, positionY);
    ref.invalidateSelf();
  }

  /// ポインター位置を更新
  Future<void> updatePointer(int pointerX, int pointerY) async {
    final circle = await future;
    await ref
        .read(circleRepositoryProvider)
        .updatePointer(circle.circleId!, pointerX, pointerY);
    ref.invalidateSelf();
  }

  /// 画像を更新
  Future<void> updateImage(String imagePath) async {
    try {
      final circle = await future;

      // ImageRepository で画像を圧縮保存（mapIdとcircleIdを渡す）
      final path = await ref
          .read(imageRepositoryProvider.notifier)
          .saveCircleImage(
            imagePath,
            mapId: circle.mapId!,
            circleId: circle.circleId!,
          );

      await ref
          .read(circleRepositoryProvider)
          .updateImagePath(circle.circleId!, path);

      ref.invalidateSelf();
    } on ImageOperationException catch (e) {
      debugPrint('Failed to update circle image: $e');
      rethrow;
    }
  }

  /// メニュー画像を更新
  Future<void> updateMenuImage(String menuImagePath) async {
    try {
      final circle = await future;

      // ImageRepository で画像を圧縮保存（mapIdとcircleIdを渡す）
      final path = await ref
          .read(imageRepositoryProvider.notifier)
          .saveCircleMenuImage(
            menuImagePath,
            mapId: circle.mapId!,
            circleId: circle.circleId!,
          );

      await ref
          .read(circleRepositoryProvider)
          .updateMenuImagePath(circle.circleId!, path);

      ref.invalidateSelf();
    } on ImageOperationException catch (e) {
      debugPrint('Failed to update menu image: $e');
      rethrow;
    }
  }

  /// 完了状態をトグル
  Future<void> toggleDone() async {
    final circle = await future;
    final newIsDone = circle.isDone == 1 ? false : true;
    await ref
        .read(circleRepositoryProvider)
        .updateIsDone(circle.circleId!, newIsDone);
    ref.invalidateSelf();
  }
}
