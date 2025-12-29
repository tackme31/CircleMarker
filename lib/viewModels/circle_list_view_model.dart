import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/states/circle_list_state.dart';
import 'package:circle_marker/utils/enums.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'circle_list_view_model.g.dart';

@riverpod
class CircleListViewModel extends _$CircleListViewModel {
  @override
  Future<CircleListState> build() async {
    return _loadCircles(SortType.mapName, SortDirection.asc, [], '');
  }

  Future<CircleListState> _loadCircles(
    SortType sortType,
    SortDirection sortDirection,
    List<int> selectedMapIds,
    String searchQuery,
  ) async {
    final circles = await ref
        .read(circleRepositoryProvider)
        .searchCirclesSorted(
          searchQuery: searchQuery,
          sortType: sortType,
          sortDirection: sortDirection,
          mapIds: selectedMapIds.isEmpty ? null : selectedMapIds,
          offset: 0,
          limit: 20,
        );
    return CircleListState(
      circles: circles,
      sortType: sortType,
      sortDirection: sortDirection,
      selectedMapIds: selectedMapIds,
      searchQuery: searchQuery,
      hasMore: circles.length == 20,
      currentOffset: 0,
      pageSize: 20,
      isLoadingMore: false,
    );
  }

  Future<void> setSort(SortType sortType, SortDirection sortDirection) async {
    state = const AsyncValue.loading();
    final currentState = state.value;
    state = await AsyncValue.guard(
      () => _loadCircles(
        sortType,
        sortDirection,
        currentState?.selectedMapIds ?? [],
        currentState?.searchQuery ?? '',
      ),
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
        currentState?.searchQuery ?? '',
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
          currentState.searchQuery,
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
          currentState.searchQuery,
        ),
      );
    }
  }

  Future<void> searchCircles(String query) async {
    state = const AsyncValue.loading();
    final currentState = state.value;

    state = await AsyncValue.guard(() async {
      final circles = await ref
          .read(circleRepositoryProvider)
          .searchCirclesSorted(
            searchQuery: query,
            sortType: currentState?.sortType ?? SortType.mapName,
            sortDirection: currentState?.sortDirection ?? SortDirection.asc,
            mapIds: currentState?.selectedMapIds.isEmpty ?? true
                ? null
                : currentState?.selectedMapIds,
          );

      return CircleListState(
        circles: circles,
        sortType: currentState?.sortType ?? SortType.mapName,
        sortDirection: currentState?.sortDirection ?? SortDirection.asc,
        selectedMapIds: currentState?.selectedMapIds ?? [],
        searchQuery: query,
      );
    });
  }

  void clearSearch() {
    searchCircles('');
  }

  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    // Set loading flag
    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    final nextOffset = currentState.currentOffset + currentState.pageSize;

    try {
      final newCircles = await ref
          .read(circleRepositoryProvider)
          .searchCirclesSorted(
            searchQuery: currentState.searchQuery,
            sortType: currentState.sortType,
            sortDirection: currentState.sortDirection,
            mapIds: currentState.selectedMapIds.isEmpty
                ? null
                : currentState.selectedMapIds,
            offset: nextOffset,
            limit: currentState.pageSize,
          );

      state = AsyncValue.data(
        currentState.copyWith(
          circles: [...currentState.circles, ...newCircles],
          currentOffset: nextOffset,
          hasMore: newCircles.length == currentState.pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      // Clear loading flag on error
      state = AsyncValue.data(currentState.copyWith(isLoadingMore: false));
      state = AsyncValue.error(e, st);
    }
  }
}
