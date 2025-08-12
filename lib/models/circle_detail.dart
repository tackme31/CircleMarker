import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_detail.freezed.dart';
part 'circle_detail.g.dart';

@freezed
class CircleDetail with _$CircleDetail {
  const factory CircleDetail({
    int? circleId,
    int? mapId,
    int? positionX,
    int? positionY,
    int? sizeHeight,
    int? sizeWidth,
    int? pointerX,
    int? pointerY,
    String? circleName,
    String? spaceNo,
    String? imagePath,
    String? note,
    String? description,
  }) = _CircleDetail;

  factory CircleDetail.fromJson(Map<String, dynamic> json) => _$CircleDetailFromJson(json);
}