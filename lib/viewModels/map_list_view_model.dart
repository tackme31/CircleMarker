import 'package:circle_marker/models/map_detail.dart';
import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/repositories/map_repository.dart';
import 'package:circle_marker/states/map_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_list_view_model.g.dart';

@Riverpod(dependencies: [mapRepository, circleRepository])
class MapListViewModel extends _$MapListViewModel {
  late final MapRepository _mapRepository;
  late final CircleRepository _circleRepository;

  @override
  Future<MapListState> build() async {
    _mapRepository = ref.watch(mapRepositoryProvider);
    _circleRepository = ref.watch(circleRepositoryProvider);

    final maps = await _mapRepository.getMapDetails();
    return MapListState(maps: maps);
  }

  Future<MapDetail> addMapDetail(String imagePath) async {
    final mapDetail = MapDetail(title: 'New Map', baseImagePath: imagePath);
    final insertedMap = await _mapRepository.insertMapDetail(mapDetail);

    // 追加後に最新のリストを取得して状態更新
    final maps = await _mapRepository.getMapDetails();
    state = AsyncData(MapListState(maps: maps));

    return insertedMap;
  }

  Future<void> refreshMaps() async {
    final maps = await _mapRepository.getMapDetails();
    state = AsyncData(MapListState(maps: maps));
  }

  Future<void> removeMap(int mapId) async {
    await _mapRepository.deleteMapDetail(mapId);
    await _circleRepository.deleteCircles(mapId);

    // 削除後に最新のリストを取得して状態更新
    final maps = await _mapRepository.getMapDetails();
    state = AsyncData(MapListState(maps: maps));
  }
}
