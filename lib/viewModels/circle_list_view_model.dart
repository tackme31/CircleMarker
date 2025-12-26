import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/states/circle_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'circle_list_view_model.g.dart';

@riverpod
class CircleListViewModel extends _$CircleListViewModel {
  @override
  Future<CircleListState> build() async {
    return _loadCircles(SortType.mapName, SortDirection.asc);
  }

  Future<CircleListState> _loadCircles(
    SortType sortType,
    SortDirection sortDirection,
  ) async {
    final sortTypeStr = sortType == SortType.mapName ? 'mapName' : 'spaceNo';
    final sortDirStr = sortDirection == SortDirection.asc ? 'asc' : 'desc';

    final circles = await ref
        .read(circleRepositoryProvider)
        .getAllCirclesSorted(sortType: sortTypeStr, sortDirection: sortDirStr);
    return CircleListState(
      circles: circles,
      sortType: sortType,
      sortDirection: sortDirection,
    );
  }

  Future<void> setSort(SortType sortType, SortDirection sortDirection) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadCircles(sortType, sortDirection));
  }
}
