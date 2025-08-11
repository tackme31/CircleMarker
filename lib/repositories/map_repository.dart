import 'package:circle_marker/models/map_summary.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_repository.g.dart';

@riverpod
MapRepository mapRepository(Ref _) {
  return MapRepository();
}

class MapRepository {
  Future<List<MapSummary>> getMapSummaries() async {
    return [
      MapSummary(mapId: 0, title: 'C106 東123'),
      MapSummary(mapId: 1, title: 'C106 東456'),
      MapSummary(mapId: 2, title: 'C106 東7'),
      MapSummary(mapId: 3, title: 'C106 西12')
    ];
  }
}