import 'package:circle_marker/models/map_summary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_list_state.freezed.dart';

@freezed
class MapListState with _$MapListState {
  const factory MapListState({
    @Default([]) List<MapSummary> maps,
  }) = _MapListState;
}