import 'package:circle_marker/models/map_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_detail_state.freezed.dart';

@freezed
class MapDetailState with _$MapDetailState {
  const factory MapDetailState({
    MapDetail? mapDetail,
  }) = _MapDetailState;
}