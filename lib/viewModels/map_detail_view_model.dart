import 'dart:io';

import 'package:circle_marker/models/circle_detail.dart';
import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/repositories/map_repository.dart';
import 'package:circle_marker/states/map_detail_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

part 'map_detail_view_model.g.dart';

@Riverpod(dependencies: [mapRepository, circleRepository])
class MapDetailViewModel extends _$MapDetailViewModel {
  late final MapRepository _mapRepository;

  @override
  Future<MapDetailState> build(int mapId) async {
    _mapRepository = ref.watch(mapRepositoryProvider);

    final map = await _mapRepository.getMapDetail(mapId);

    final file = File(map.baseImagePath!);
    final decoded = await decodeImageFromList(await file.readAsBytes());
    final baseImageSize = Size(
      decoded.width.toDouble(),
      decoded.height.toDouble(),
    );

    return MapDetailState(
      mapDetail: map,
      baseImage: file,
      baseImageSize: baseImageSize,
      circles: [
        CircleDetail(
          circleId: 0,
          positionX: 100,
          positionY: 100,
          sizeWidth: 200,
          sizeHeight: 250,
          mapId: mapId,
          circleName: 'Circle A',
          spaceNo: 'A-12b',
          imagePath: null,
          note: 'Note A',
          description: 'Description A',
        ),
        CircleDetail(
          circleId: 1,
          positionX: 400,
          positionY: 400,
          sizeWidth: 200,
          sizeHeight: 250,
          mapId: mapId,
          circleName: 'Circle B',
          spaceNo: 'カ-04ab',
          imagePath: '/path/to/imageA.png',
          note: null,
          description: 'Description A',
        ),
      ],
    );
  }
}
