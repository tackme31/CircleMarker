// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MapDetailImpl _$$MapDetailImplFromJson(Map<String, dynamic> json) =>
    _$MapDetailImpl(
      mapId: (json['mapId'] as num?)?.toInt(),
      title: json['title'] as String?,
      baseImagePath: json['baseImagePath'] as String?,
    );

Map<String, dynamic> _$$MapDetailImplToJson(_$MapDetailImpl instance) =>
    <String, dynamic>{
      'mapId': instance.mapId,
      'title': instance.title,
      'baseImagePath': instance.baseImagePath,
    };
