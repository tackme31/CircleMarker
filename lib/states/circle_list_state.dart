import 'package:circle_marker/repositories/circle_with_map_title.dart';
import 'package:circle_marker/utils/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_list_state.freezed.dart';

@freezed
class CircleListState with _$CircleListState {
  const factory CircleListState({
    @Default([]) List<CircleWithMapTitle> circles,
    @Default(SortType.mapName) SortType sortType,
    @Default(SortDirection.asc) SortDirection sortDirection,
    @Default([]) List<int> selectedMapIds,
    @Default('') String searchQuery,
    // Pagination fields
    @Default(false) bool hasMore,
    @Default(0) int currentOffset,
    @Default(20) int pageSize,
    @Default(false) bool isLoadingMore,
  }) = _CircleListState;
}
