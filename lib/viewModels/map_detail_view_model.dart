import 'package:circle_marker/repositories/map_repository.dart';
import 'package:circle_marker/states/map_detail_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_detail_view_model.g.dart';

@Riverpod(dependencies: [mapRepository])
class MapDetailViewModel extends _$MapDetailViewModel {
  late final MapRepository _mapRepository;

  @override
  Future<MapDetailState> build(int mapId) async {
    _mapRepository = ref.watch(mapRepositoryProvider);

    final map = await _mapRepository.getMapDetail(mapId);
    return MapDetailState(mapDetail: map);
  }
}