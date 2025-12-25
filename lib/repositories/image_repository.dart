import 'dart:io';
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

  /// マップ画像を保存し、サムネイルを生成する
  ///
  /// [sourcePath] 元画像のパス
  /// Returns: 元画像とサムネイルのパス情報
  /// Throws: [ImageOperationException] 画像処理に失敗した場合
  Future<MapImagePaths> saveMapImageWithThumbnail(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // ディレクトリ作成
    final originalDir = Directory('${dir.path}/maps');
    final thumbnailDir = Directory('${dir.path}/maps/thumbnails');
    await originalDir.create(recursive: true);
    await thumbnailDir.create(recursive: true);

    // パス生成
    final originalPath = '${originalDir.path}/$timestamp.jpg';
    final thumbnailPath = '${thumbnailDir.path}/${timestamp}_thumb.jpg';

    try {
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

      return MapImagePaths(
        original: originalPath,
        thumbnail: thumbnailPath,
      );
    } on FileSystemException catch (e) {
      throw ImageOperationException('Failed to save image', e);
    } catch (e) {
      throw ImageOperationException('Unexpected error during image processing', e);
    }
  }

  /// サークル画像を保存 (圧縮のみ)
  ///
  /// [sourcePath] 元画像のパス
  /// Returns: 圧縮後の画像パス
  /// Throws: [ImageOperationException] 画像処理に失敗した場合
  Future<String> saveCircleImage(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final circleDir = Directory('${dir.path}/circles');
    await circleDir.create(recursive: true);

    final outputPath = '${circleDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
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
      throw ImageOperationException('Unexpected error during circle image processing', e);
    }
  }
}
