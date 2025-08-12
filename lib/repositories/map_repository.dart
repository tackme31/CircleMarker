import 'package:circle_marker/models/map_detail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_repository.g.dart';

@riverpod
MapRepository mapRepository(Ref _) {
  return MapRepository();
}

class MapRepository {
  Future<List<MapDetail>> getMapDetails() async {
    return [
      MapDetail(
        mapId: 0,
        title: 'C106 東123',
        baseImagePath:
            '/data/user/0/com.example.circle_marker/cache/72fed813-b226-4bd5-b093-97b0ccc78bed/1000000033.png',
      ),
      MapDetail(
        mapId: 1,
        title: 'C106 東456',
        baseImagePath:
            '/data/user/0/com.example.circle_marker/cache/72fed813-b226-4bd5-b093-97b0ccc78bed/1000000033.png',
      ),
      MapDetail(
        mapId: 2,
        title: 'C106 西12',
        baseImagePath:
            '/data/user/0/com.example.circle_marker/cache/72fed813-b226-4bd5-b093-97b0ccc78bed/1000000033.png',
      ),
    ];
  }

  Future<MapDetail> getMapDetail(int mapId) async {
    // Return a dummy MapDetail for the given mapId
    return MapDetail(
      mapId: mapId,
      title: 'C106 東123',
      baseImagePath:
          '/data/user/0/com.example.circle_marker/cache/72fed813-b226-4bd5-b093-97b0ccc78bed/1000000033.png',
    );
  }
}
