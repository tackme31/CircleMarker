import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:circle_marker/exceptions/app_exceptions.dart';

part 'image_repository.g.dart';
part 'image_repository.freezed.dart';

/// マップ画像のパス情報を保持するクラス
@freezed
class MapImagePaths with _$MapImagePaths {
  const factory MapImagePaths({
    required String original,
    required String thumbnail,
  }) = _MapImagePaths;
}

/// 画像の保存・圧縮を管理するリポジトリ
@riverpod
class ImageRepository extends _$ImageRepository {
  @override
  void build() {
    // 初期化処理は不要
  }

  // ============================================
  // パス生成ヘルパーメソッド（新構造用）
  // ============================================

  /// マップディレクトリのパスを取得
  Future<String> _getMapDirectoryPath(int mapId) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/maps/$mapId';
  }

  /// マップ画像のパスを取得
  Future<String> _getMapImagePath(int mapId) async {
    final mapDir = await _getMapDirectoryPath(mapId);
    return '$mapDir/base_image.jpg';
  }

  /// マップサムネイルのパスを取得
  Future<String> _getMapThumbnailPath(int mapId) async {
    final mapDir = await _getMapDirectoryPath(mapId);
    return '$mapDir/thumbnail.jpg';
  }

  /// サークル画像のパスを取得
  Future<String> _getCircleImagePath(int mapId, int circleId) async {
    final mapDir = await _getMapDirectoryPath(mapId);
    return '$mapDir/circles/$circleId.jpg';
  }

  /// サークルメニュー画像のパスを取得
  Future<String> _getCircleMenuImagePath(int mapId, int circleId) async {
    final mapDir = await _getMapDirectoryPath(mapId);
    return '$mapDir/circles/${circleId}_menu.jpg';
  }

  /// 画像キャッシュをクリアする
  ///
  /// [imagePath] クリア対象の画像パス
  ///
  /// 画像を差し替える際、同じパスで異なる画像になるとImageProviderのキャッシュ問題が発生するため、
  /// 画像の保存・コピー前にキャッシュをクリアする
  void _clearImageCache(String imagePath) {
    try {
      final imageFile = File(imagePath);
      if (imageFile.existsSync()) {
        final fileImage = FileImage(imageFile);
        fileImage.evict();
        debugPrint('Cleared image cache for: $imagePath');
      }
    } catch (e) {
      // キャッシュクリアの失敗はログのみ(処理は継続)
      debugPrint('Failed to clear image cache for $imagePath: $e');
    }
  }

  /// マップ画像を保存し、サムネイルを生成する
  ///
  /// [sourcePath] 元画像のパス
  /// [mapId] マップID（新構造用のディレクトリパスに使用）
  /// Returns: 元画像とサムネイルのパス情報
  /// Throws: [ImageOperationException] 画像処理に失敗した場合
  Future<MapImagePaths> saveMapImageWithThumbnail(
    String sourcePath, {
    required int mapId,
  }) async {
    // パス生成
    final originalPath = await _getMapImagePath(mapId);
    final thumbnailPath = await _getMapThumbnailPath(mapId);

    // ディレクトリ作成
    final originalDir = Directory(originalPath).parent;
    await originalDir.create(recursive: true);

    try {
      // キャッシュクリア(画像差し替え時のキャッシュ問題対策)
      _clearImageCache(originalPath);
      _clearImageCache(thumbnailPath);

      // 元画像を保存
      await File(sourcePath).copy(originalPath);

      // サムネイル生成 (512x512 最大、品質85%)
      final result = await FlutterImageCompress.compressAndGetFile(
        sourcePath,
        thumbnailPath,
        minWidth: 512,
        minHeight: 512,
        quality: 85,
      );

      if (result == null) {
        throw ImageOperationException('Failed to compress thumbnail');
      }

      return MapImagePaths(original: originalPath, thumbnail: thumbnailPath);
    } on FileSystemException catch (e) {
      throw ImageOperationException('Failed to save image', e);
    } catch (e) {
      throw ImageOperationException(
        'Unexpected error during image processing',
        e,
      );
    }
  }

  /// サークル画像を保存 (圧縮のみ)
  ///
  /// [sourcePath] 元画像のパス
  /// [mapId] マップID
  /// [circleId] サークルID
  /// Returns: 圧縮後の画像パス
  /// Throws: [ImageOperationException] 画像処理に失敗した場合
  Future<String> saveCircleImage(
    String sourcePath, {
    required int mapId,
    required int circleId,
  }) async {
    final outputPath = await _getCircleImagePath(mapId, circleId);

    // ディレクトリ作成
    final circleDir = Directory(outputPath).parent;
    await circleDir.create(recursive: true);

    try {
      // キャッシュクリア(画像差し替え時のキャッシュ問題対策)
      _clearImageCache(outputPath);

      final result = await FlutterImageCompress.compressAndGetFile(
        sourcePath,
        outputPath,
        minWidth: 300,
        minHeight: 300,
        quality: 90,
      );

      if (result == null) {
        throw ImageOperationException('Failed to compress circle image');
      }

      return outputPath;
    } on FileSystemException catch (e) {
      throw ImageOperationException('Failed to save circle image', e);
    } catch (e) {
      throw ImageOperationException(
        'Unexpected error during circle image processing',
        e,
      );
    }
  }

  /// サークルメニュー画像を保存 (圧縮なし)
  ///
  /// [sourcePath] 元画像のパス
  /// [mapId] マップID
  /// [circleId] サークルID
  /// Returns: コピー後の画像パス
  /// Throws: [ImageOperationException] 画像処理に失敗した場合
  Future<String> saveCircleMenuImage(
    String sourcePath, {
    required int mapId,
    required int circleId,
  }) async {
    final outputPath = await _getCircleMenuImagePath(mapId, circleId);
    final outputFile = File(outputPath);
    final inputFile = File(sourcePath);

    // ディレクトリ作成
    if (!await outputFile.parent.exists()) {
      await outputFile.parent.create(recursive: true);
    }

    try {
      // キャッシュクリア(画像差し替え時のキャッシュ問題対策)
      _clearImageCache(outputPath);

      await inputFile.copy(outputPath);

      return outputPath;
    } on FileSystemException catch (e) {
      throw ImageOperationException('Failed to save menu image', e);
    } catch (e) {
      throw ImageOperationException(
        'Unexpected error during menu image processing',
        e,
      );
    }
  }

  /// マップディレクトリ全体を削除（新構造専用）
  ///
  /// [mapId] マップID
  /// Returns: 削除が成功した場合true、ディレクトリが存在しない場合false
  Future<bool> deleteMapDirectory(int mapId) async {
    try {
      final mapDirPath = await _getMapDirectoryPath(mapId);
      final mapDir = Directory(mapDirPath);

      if (await mapDir.exists()) {
        await mapDir.delete(recursive: true);
        debugPrint('Deleted map directory: $mapDirPath');
        return true;
      } else {
        debugPrint('Map directory not found (already deleted?): $mapDirPath');
        return false;
      }
    } on FileSystemException catch (e) {
      debugPrint('Failed to delete map directory: $mapId - ${e.message}');
      // エラーがあっても例外をスローしない（ログのみ）
      return false;
    }
  }
}
