import 'dart:io';

import 'package:circle_marker/models/circle_detail.dart';
import 'package:circle_marker/viewModels/map_detail_view_model.dart';
import 'package:circle_marker/views/widgets/circle_box.dart';
import 'package:circle_marker/views/widgets/editable_image.dart';
import 'package:circle_marker/views/widgets/editable_label.dart';
import 'package:circle_marker/views/widgets/pixel_positioned.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MapDetailScreen extends ConsumerStatefulWidget {
  const MapDetailScreen({super.key, required this.mapId});

  final int mapId;

  @override
  ConsumerState<MapDetailScreen> createState() => _MapDetailScreenState();
}

class _MapDetailScreenState extends ConsumerState<MapDetailScreen> {
  final TransformationController _controller = TransformationController();
  PersistentBottomSheetController? _sheetController;
  late final MapDetailViewModel viewModel;
  int? selectedCircleId;

  Future _onDoubleTap(
    BuildContext context,
    TapDownDetails details,
    Size stackSize,
    Size imageOriginalSize,
  ) async {
    // Stack内でfit: BoxFit.containで画像が表示されるサイズを計算
    final imageAspect = imageOriginalSize.width / imageOriginalSize.height;
    final stackAspect = stackSize.width / stackSize.height;

    double displayWidth, displayHeight;
    double offsetX = 0, offsetY = 0;

    if (imageAspect > stackAspect) {
      displayWidth = stackSize.width;
      displayHeight = displayWidth / imageAspect;
      offsetY = (stackSize.height - displayHeight) / 2;
    } else {
      displayHeight = stackSize.height;
      displayWidth = displayHeight * imageAspect;
      offsetX = (stackSize.width - displayWidth) / 2;
    }

    // InteractiveViewerの変換行列
    final matrix = _controller.value;
    final scale = matrix.getMaxScaleOnAxis();
    final pan = Offset(matrix.row0[3], matrix.row1[3]);

    // 1. panを引く
    final pos1 = details.localPosition - pan;
    // 2. scaleで割る
    final pos2 = pos1 / scale;
    // 3. 画像の余白を引く
    final imageLocal = pos2 - Offset(offsetX, offsetY);

    // 画像表示サイズ→画像ピクセル座標へ変換
    final imgX = imageLocal.dx * (imageOriginalSize.width / displayWidth);
    final imgY = imageLocal.dy * (imageOriginalSize.height / displayHeight);

    await viewModel.addCircleDetail(
      widget.mapId,
      imgX.toInt(),
      imgY.toInt(),
      200,
      250,
    );
  }

  Future _onCircleDragEnd(int newPixelX, int newPixelY, int circleId) async {
    await viewModel.updateCirclePosition(
      circleId,
      newPixelX.toDouble(),
      newPixelY.toDouble(),
    );
  }

  void _onCircleTap(BuildContext context, CircleDetail circle) {
    if (selectedCircleId == circle.circleId) {
      setState(() {
        selectedCircleId = null; // 選択解除
        _sheetController?.close();
      });
    } else {
      setState(() {
        selectedCircleId = circle.circleId; // 新しいサークルを選択
      });

      _sheetController = showBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (BuildContext context) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: screenWidth * 0.8,
              height: screenHeight * 0.3,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CircleName: '),
                    EditableLabel(
                      initialText: circle.circleName ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      onSubmit: (value) {
                        //
                      },
                    ),
                    Gap(8),
                    Text('Space No:'),
                    EditableLabel(
                      initialText: circle.spaceNo ?? 'No Space No',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      onSubmit: (value) {
                        //
                      },
                    ),
                    Gap(8),
                    Text('Note:'),
                    EditableLabel(
                      initialText: circle.note ?? 'No Note',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: null,
                      onSubmit: (value) {
                        //
                      },
                    ),
                    Gap(8),
                    Text('Description:'),
                    EditableLabel(
                      initialText: circle.description ?? 'No Description',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: null,
                      onSubmit: (value) {
                        //
                      },
                    ),
                    Gap(8),
                    EditableImage(
                      image:
                          circle.imagePath != null &&
                              File(circle.imagePath!).existsSync()
                          ? FileImage(File(circle.imagePath!))
                          : AssetImage('assets/no_image.png'),
                      onChange: (imagePath) {
                        
                      },
                    ),
                    Gap(8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.pop(context);
                        await viewModel.removeCircle(circle.circleId!);
                      },
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text(
                        '削除',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
      _sheetController!.closed.then((_) {
        if (mounted) {
          setState(() {
            selectedCircleId = null; // サークル選択解除
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(mapDetailViewModelProvider(widget.mapId).notifier);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapDetailViewModelProvider(widget.mapId));

    return Scaffold(
      appBar: AppBar(
        title: switch (state) {
          AsyncData(:final value) when value.mapDetail.title != null =>
            EditableLabel(
              initialText: value.mapDetail.title!,
              onSubmit: (newTitle) async {
                await viewModel.updateMapTile(newTitle);
              },
            ),
          AsyncError() => const Text('Error'),
          _ => const Text('Loading...'),
        },
      ),
      body: switch (state) {
        AsyncData(:final value) => Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Stackの表示サイズ
                  final imageDisplaySize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  return GestureDetector(
                    onDoubleTapDown: (details) => _onDoubleTap(
                      context,
                      details,
                      imageDisplaySize,
                      value.baseImageSize,
                    ),
                    child: InteractiveViewer(
                      transformationController: _controller,
                      minScale: 0.5,
                      maxScale: 10.0,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.file(
                              value.baseImage,
                              fit: BoxFit.contain,
                            ),
                          ),
                          ...value.circles.map((circle) {
                            return Opacity(
                              opacity:
                                  selectedCircleId == null ||
                                      selectedCircleId == circle.circleId
                                  ? 1.0
                                  : 0.5,
                              child: Stack(
                                children: [
                                  /* IgnorePointer(
                                    child: LineBetweenPixels(
                                      startPixelX:
                                          circle.positionX! +
                                          circle.sizeWidth! ~/ 2,
                                      startPixelY:
                                          circle.positionY! +
                                          circle.sizeHeight! ~/ 2,
                                      endPixelX: 1000,
                                      endPixelY: 1000,
                                      imageOriginalSize: value.baseImageSize,
                                      imageDisplaySize: imageDisplaySize,
                                      color: Colors.blue,
                                      strokeWidth: 3,
                                    ),
                                  ), */
                                  PixelPositioned(
                                    pixelX: circle.positionX!,
                                    pixelY: circle.positionY!,
                                    imageDisplaySize: imageDisplaySize,
                                    imageOriginalSize: value.baseImageSize,
                                    onTap: () => _onCircleTap(context, circle),
                                    onDragEnd: (x, y) => _onCircleDragEnd(
                                      x,
                                      y,
                                      circle.circleId!,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleBox(
                                          pixelWidth: circle.sizeWidth!,
                                          pixleHeight: circle.sizeHeight!,
                                          imageDisplaySize: imageDisplaySize,
                                          imageOriginalSize:
                                              value.baseImageSize,
                                          imagePath: circle.imagePath,
                                        ),
                                        if (circle.circleName != null)
                                          SizedBox(
                                            width:
                                                circle.sizeWidth! *
                                                (imageDisplaySize.width /
                                                    value.baseImageSize.width),
                                            child: Text(
                                              circle.circleName!,
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    24 *
                                                    (imageDisplaySize.width /
                                                        value
                                                            .baseImageSize
                                                            .width),
                                              ),
                                            ),
                                          ),
                                        if (circle.spaceNo != null)
                                          SizedBox(
                                            width:
                                                circle.sizeWidth! *
                                                (imageDisplaySize.width /
                                                    value.baseImageSize.width),
                                            child: Text(
                                              circle.spaceNo!,
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    24 *
                                                    (imageDisplaySize.width /
                                                        value
                                                            .baseImageSize
                                                            .width),
                                              ),
                                            ),
                                          ),
                                        if (mounted && circle.note != null)
                                          SizedBox(
                                            width:
                                                circle.sizeWidth! *
                                                (imageDisplaySize.width /
                                                    value.baseImageSize.width),
                                            child: Text(
                                              circle.note!,
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    24 *
                                                    (imageDisplaySize.width /
                                                        value
                                                            .baseImageSize
                                                            .width),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          // ここに図形を追加
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        AsyncError(:final error) => Center(
          child: Text('Something went wrong: $error'),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
