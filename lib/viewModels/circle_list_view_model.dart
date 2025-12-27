import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/states/circle_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'circle_list_view_model.g.dart';

@riverpod
class CircleListViewModel extends _$CircleListViewModel {
  @override
  Future<CircleListState> build() async {
    return _loadCircles(SortType.mapName, SortDirection.asc, []);
  }

  Future<CircleListState> _loadCircles(
    SortType sortType,
    SortDirection sortDirection,
    List<int> selectedMapIds,
  ) async {
    final sortTypeStr = sortType.displayName;
    final sortDirStr = sortDirection.displayName;

    final circles = await ref
        .read(circleRepositoryProvider)
        .getAllCirclesSorted(
          sortType: sortTypeStr,
          sortDirection: sortDirStr,
          mapIds: selectedMapIds.isEmpty ? null : selectedMapIds,
        );
    return CircleListState(
      circles: circles,
      sortType: sortType,
      sortDirection: sortDirection,
      selectedMapIds: selectedMapIds,
    );
  }

  Future<void> setSort(SortType sortType, SortDirection sortDirection) async {
    state = const AsyncValue.loading();
    final currentMapIds = state.value?.selectedMapIds ?? [];
    state = await AsyncValue.guard(
      () => _loadCircles(sortType, sortDirection, currentMapIds),
    );
  }

  Future<void> setMapFilter(List<int> mapIds) async {
    state = const AsyncValue.loading();
    final currentState = state.value;
    state = await AsyncValue.guard(
      () => _loadCircles(
        currentState?.sortType ?? SortType.mapName,
        currentState?.sortDirection ?? SortDirection.asc,
        mapIds,
      ),
    );
  }

  Future<void> refresh() async {
    final currentState = state.value;
    if (currentState != null) {
      state = await AsyncValue.guard(
        () => _loadCircles(
          currentState.sortType,
          currentState.sortDirection,
          currentState.selectedMapIds,
        ),
      );
    }
  }

  Future<void> removeCircle(int circleId) async {
    await ref.read(circleRepositoryProvider).deleteCircle(circleId);
    final currentState = state.value;
    if (currentState != null) {
      state = await AsyncValue.guard(
        () => _loadCircles(
          currentState.sortType,
          currentState.sortDirection,
          currentState.selectedMapIds,
        ),
      );
    }
  }
}
