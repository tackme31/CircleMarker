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
    @Default([]) List<int> selectedMapIds,
    @Default('') String searchQuery,
  }) = _CircleListState;
}

extension SortTypeExtension on SortType {
  String get displayName {
    switch (this) {
      case SortType.mapName:
        return 'mapName';
      case SortType.spaceNo:
        return 'spaceNo';
    }
  }
}

extension SortDirectionExtension on SortDirection {
  String get displayName {
    switch (this) {
      case SortDirection.asc:
        return 'asc';
      case SortDirection.desc:
        return 'desc';
    }
  }
}
