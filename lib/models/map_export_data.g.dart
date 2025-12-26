// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_export_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MapExportDataImpl _$$MapExportDataImplFromJson(Map<String, dynamic> json) =>
    _$MapExportDataImpl(
      manifest: MapExportManifest.fromJson(
        json['manifest'] as Map<String, dynamic>,
      ),
      content: MapExportContent.fromJson(
        json['content'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$MapExportDataImplToJson(_$MapExportDataImpl instance) =>
    <String, dynamic>{
      'manifest': instance.manifest,
      'content': instance.content,
    };

_$MapExportManifestImpl _$$MapExportManifestImplFromJson(
  Map<String, dynamic> json,
) => _$MapExportManifestImpl(
  version: json['version'] as String,
  exportDate: json['exportDate'] as String,
);

Map<String, dynamic> _$$MapExportManifestImplToJson(
  _$MapExportManifestImpl instance,
) => <String, dynamic>{
  'version': instance.version,
  'exportDate': instance.exportDate,
};

_$MapExportContentImpl _$$MapExportContentImplFromJson(
  Map<String, dynamic> json,
) => _$MapExportContentImpl(
  map: MapExportMapData.fromJson(json['map'] as Map<String, dynamic>),
  circles: (json['circles'] as List<dynamic>)
      .map((e) => CircleExportData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$MapExportContentImplToJson(
  _$MapExportContentImpl instance,
) => <String, dynamic>{'map': instance.map, 'circles': instance.circles};

_$MapExportMapDataImpl _$$MapExportMapDataImplFromJson(
  Map<String, dynamic> json,
) => _$MapExportMapDataImpl(
  title: json['title'] as String,
  baseImagePath: json['baseImagePath'] as String,
  thumbnailPath: json['thumbnailPath'] as String?,
);

Map<String, dynamic> _$$MapExportMapDataImplToJson(
  _$MapExportMapDataImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'baseImagePath': instance.baseImagePath,
  'thumbnailPath': instance.thumbnailPath,
};

_$CircleExportDataImpl _$$CircleExportDataImplFromJson(
  Map<String, dynamic> json,
) => _$CircleExportDataImpl(
  positionX: (json['positionX'] as num).toInt(),
  positionY: (json['positionY'] as num).toInt(),
  sizeWidth: (json['sizeWidth'] as num).toInt(),
  sizeHeight: (json['sizeHeight'] as num).toInt(),
  pointerX: (json['pointerX'] as num).toInt(),
  pointerY: (json['pointerY'] as num).toInt(),
  circleName: json['circleName'] as String,
  spaceNo: json['spaceNo'] as String,
  imagePath: json['imagePath'] as String?,
  menuImagePath: json['menuImagePath'] as String?,
  note: json['note'] as String?,
  description: json['description'] as String?,
  color: json['color'] as String?,
  isDone: (json['isDone'] as num).toInt(),
);

Map<String, dynamic> _$$CircleExportDataImplToJson(
  _$CircleExportDataImpl instance,
) => <String, dynamic>{
  'positionX': instance.positionX,
  'positionY': instance.positionY,
  'sizeWidth': instance.sizeWidth,
  'sizeHeight': instance.sizeHeight,
  'pointerX': instance.pointerX,
  'pointerY': instance.pointerY,
  'circleName': instance.circleName,
  'spaceNo': instance.spaceNo,
  'imagePath': instance.imagePath,
  'menuImagePath': instance.menuImagePath,
  'note': instance.note,
  'description': instance.description,
  'color': instance.color,
  'isDone': instance.isDone,
};
