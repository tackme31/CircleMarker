import 'dart:io';
import 'dart:ui';

import 'package:circle_marker/models/map_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_detail_state.freezed.dart';

@freezed
class MapDetailState with _$MapDetailState {
  const factory MapDetailState({
    required MapDetail mapDetail,
    required File baseImage,
    required Size baseImageSize,
  }) = _MapDetailState;
}