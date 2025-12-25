import 'package:circle_marker/models/map_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_list_state.freezed.dart';

@freezed
class MapListState with _$MapListState {
  const factory MapListState({@Default([]) List<MapDetail> maps}) =
      _MapListState;
}
