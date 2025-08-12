// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CircleDetailImpl _$$CircleDetailImplFromJson(Map<String, dynamic> json) =>
    _$CircleDetailImpl(
      circleId: (json['circleId'] as num?)?.toInt(),
      mapId: (json['mapId'] as num?)?.toInt(),
      positionX: (json['positionX'] as num?)?.toInt(),
      positionY: (json['positionY'] as num?)?.toInt(),
      sizeHeight: (json['sizeHeight'] as num?)?.toInt(),
      sizeWidth: (json['sizeWidth'] as num?)?.toInt(),
      pointerX: (json['pointerX'] as num?)?.toInt(),
      pointerY: (json['pointerY'] as num?)?.toInt(),
      circleName: json['circleName'] as String?,
      spaceNo: json['spaceNo'] as String?,
      imagePath: json['imagePath'] as String?,
      note: json['note'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$CircleDetailImplToJson(_$CircleDetailImpl instance) =>
    <String, dynamic>{
      'circleId': instance.circleId,
      'mapId': instance.mapId,
      'positionX': instance.positionX,
      'positionY': instance.positionY,
      'sizeHeight': instance.sizeHeight,
      'sizeWidth': instance.sizeWidth,
      'pointerX': instance.pointerX,
      'pointerY': instance.pointerY,
      'circleName': instance.circleName,
      'spaceNo': instance.spaceNo,
      'imagePath': instance.imagePath,
      'note': instance.note,
      'description': instance.description,
    };
