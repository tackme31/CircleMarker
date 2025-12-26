import 'package:circle_marker/repositories/circle_with_map_title.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_list_state.freezed.dart';

enum SortType { mapName, spaceNo }

enum SortDirection { asc, desc }

@freezed
class CircleListState with _$CircleListState {
  const factory CircleListState({
    @Default([]) List<CircleWithMapTitle> circles,
    @Default(SortType.mapName) SortType sortType,
    @Default(SortDirection.asc) SortDirection sortDirection,
  }) = _CircleListState;
}
