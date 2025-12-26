import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/repositories/map_repository.dart';
import 'package:circle_marker/states/circle_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'circle_list_view_model.g.dart';

@riverpod
class CircleListViewModel extends _$CircleListViewModel {
  @override
  Future<CircleListState> build() async {
    final circles = await ref.read(circleRepositoryProvider).getAllCircles();

    // Get unique mapIds from circles
    final mapIds = circles
        .map((circle) => circle.mapId)
        .whereType<int>()
        .toSet();

    // Fetch map details and create lookup map
    final mapNames = <int, String>{};
    for (final mapId in mapIds) {
      try {
        final mapDetail = await ref.read(mapRepositoryProvider).getMapDetail(mapId);
        if (mapDetail.title != null) {
          mapNames[mapId] = mapDetail.title!;
        }
      } catch (e) {
        // Map doesn't exist - will display as 'マップ不明' in UI
        continue;
      }
    }

    return CircleListState(circles: circles, mapNames: mapNames);
  }
}
