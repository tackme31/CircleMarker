import 'package:circle_marker/models/circle_detail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'circle_repository.g.dart';

@riverpod
CircleRepository circleRepository(Ref _) {
  return CircleRepository();
}

class CircleRepository {
  Future<List<CircleDetail>> getCircles(int mapId) async {
    return [
      CircleDetail(
        circleId: 0,
        mapId: mapId,
        circleName: 'Circle A',
        spaceNo: 'A-12b',
        imagePath: '/path/to/imageA.png',
        note: 'Note A',
        description: 'Description A',
      ),
      CircleDetail(
        circleId: 1,
        mapId: mapId,
        circleName: 'Circle B',
        spaceNo: 'カ-04ab',
        imagePath: '/path/to/imageA.png',
        note: 'Note A',
        description: 'Description A',
      ),
    ];
  }
}
