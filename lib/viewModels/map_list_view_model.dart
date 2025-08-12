import 'package:circle_marker/models/map_detail.dart';
import 'package:circle_marker/repositories/map_repository.dart';
import 'package:circle_marker/states/map_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_list_view_model.g.dart';

@Riverpod(dependencies: [mapRepository])
class MapListViewModel extends _$MapListViewModel {
  late final MapRepository _mapRepository;

  @override
  Future<MapListState> build() async {
    _mapRepository = ref.watch(mapRepositoryProvider);

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
}
