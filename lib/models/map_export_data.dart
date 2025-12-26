import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_export_data.freezed.dart';
part 'map_export_data.g.dart';

@freezed
class MapExportData with _$MapExportData {
  const factory MapExportData({
    required MapExportManifest manifest,
    required MapExportContent content,
  }) = _MapExportData;

  factory MapExportData.fromJson(Map<String, dynamic> json) =>
      _$MapExportDataFromJson(json);
}

@freezed
class MapExportManifest with _$MapExportManifest {
  const factory MapExportManifest({
    required String version,
    required String exportDate,
  }) = _MapExportManifest;

  factory MapExportManifest.fromJson(Map<String, dynamic> json) =>
      _$MapExportManifestFromJson(json);
}

@freezed
class MapExportContent with _$MapExportContent {
  const factory MapExportContent({
    required MapExportMapData map,
    required List<CircleExportData> circles,
  }) = _MapExportContent;

  factory MapExportContent.fromJson(Map<String, dynamic> json) =>
      _$MapExportContentFromJson(json);
}

@freezed
class MapExportMapData with _$MapExportMapData {
  const factory MapExportMapData({
    required String title,
    required String baseImagePath,
    String? thumbnailPath,
  }) = _MapExportMapData;

  factory MapExportMapData.fromJson(Map<String, dynamic> json) =>
      _$MapExportMapDataFromJson(json);
}

@freezed
class CircleExportData with _$CircleExportData {
  const factory CircleExportData({
    required int positionX,
    required int positionY,
    required int sizeWidth,
    required int sizeHeight,
    required int pointerX,
    required int pointerY,
    required String circleName,
    required String spaceNo,
    String? imagePath,
    String? menuImagePath,
    String? note,
    String? description,
    String? color,
    required int isDone,
  }) = _CircleExportData;

  factory CircleExportData.fromJson(Map<String, dynamic> json) =>
      _$CircleExportDataFromJson(json);
}
