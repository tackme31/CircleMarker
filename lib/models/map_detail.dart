import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_detail.freezed.dart';
part 'map_detail.g.dart';

@freezed
class MapDetail with _$MapDetail {
  const factory MapDetail({
    int? mapId,
    String? title,
    String? baseImagePath,
  }) = _MapDetail;

  factory MapDetail.fromJson(Map<String, dynamic> json) => _$MapDetailFromJson(json);
}