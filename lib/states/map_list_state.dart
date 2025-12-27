import 'package:circle_marker/repositories/map_with_circle_count.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_list_state.freezed.dart';

@freezed
class MapListState with _$MapListState {
  const factory MapListState({
    @Default([]) List<MapWithCircleCount> maps,
    @Default('') String searchQuery,
  }) = _MapListState;
}
