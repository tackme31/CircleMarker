import 'dart:io';

import 'package:circle_marker/models/circle_detail.dart';
import 'package:circle_marker/viewModels/map_detail_view_model.dart';
import 'package:circle_marker/views/widgets/circle_box.dart';
import 'package:circle_marker/views/widgets/draggable_line.dart';
import 'package:circle_marker/views/widgets/editable_image.dart';
import 'package:circle_marker/views/widgets/editable_label.dart';
import 'package:circle_marker/views/widgets/pixel_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

class MapDetailScreen extends ConsumerStatefulWidget {
  const MapDetailScreen({super.key, required this.mapId});

  final int mapId;

  @override
  ConsumerState<MapDetailScreen> createState() => _MapDetailScreenState();
}

class _MapDetailScreenState extends ConsumerState<MapDetailScreen> {
  final TransformationController _transformController =
      TransformationController();
  PersistentBottomSheetController? _sheetController;
  late final MapDetailViewModel viewModel;
  int? selectedCircleId;
  double _currentScale = 1.0;
  bool _orientationLocked = false;

  Future _onLongPressStart(
    BuildContext context,
    LongPressStartDetails details,
    Size stackSize,
    Size imageOriginalSize,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('サークル追加'),
          content: const Text('サークルを追加しますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return; // ユーザーがキャンセルした場合は何もしない
    }

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
    final matrix = _transformController.value;
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

  void _onTransformChanged() {
    final newScale = _transformController.value.getMaxScaleOnAxis();
    if (newScale != _currentScale) {
      setState(() {
        _currentScale = newScale;
      });
    }
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
          final ImageProvider menuImage =
              circle.menuImagePath != null &&
                  File(circle.menuImagePath!).existsSync()
              ? FileImage(File(circle.menuImagePath!))
              : AssetImage('assets/no_image.png');

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
                      onSubmit: (value) async {
                        if (value.isEmpty) {
                          return;
                        }
                        await viewModel.updateCircleName(
                          circle.circleId!,
                          value,
                        );
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
                      onSubmit: (value) async {
                        if (value.isEmpty) {
                          return;
                        }
                        await viewModel.updateCircleSpaceNo(
                          circle.circleId!,
                          value,
                        );
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
                      onSubmit: (value) async {
                        if (value.isEmpty) {
                          return;
                        }
                        await viewModel.updateCircleNote(
                          circle.circleId!,
                          value,
                        );
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
                      onSubmit: (value) async {
                        if (value.isEmpty) {
                          return;
                        }
                        await viewModel.updateCircleDescription(
                          circle.circleId!,
                          value,
                        );
                      },
                    ),
                    Gap(8),
                    EditableImage(
                      image: menuImage,
                      onChange: (value) async {
                        if (value.isEmpty) {
                          return;
                        }
                        await viewModel.updateCircleMenuImage(
                          circle.circleId!,
                          value,
                        );
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PhotoView(imageProvider: menuImage),
                          ),
                        );
                      },
                    ),
                    Gap(8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await viewModel.removeCircle(selectedCircleId!);
                        Navigator.pop(context);
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

  void _handleDoubleTap(Offset tapPos) {
    final currentScale = _transformController.value.getMaxScaleOnAxis();
    double targetScale;

    final scale1 = 1.0;
    final scale2 = 3.0;
    final scale3 = 5.0;

    if (currentScale < scale2) {
      targetScale = scale2;
    } else if (currentScale < scale3) {
      targetScale = scale3;
    } else {
      targetScale = scale1; // 100%
    }

    final matrix = _transformController.value.clone();

    // 現在のパン量
    final currentTranslation = Offset(matrix.row0[3], matrix.row1[3]);

    // タップ位置をズーム中心に変換
    final focalBefore = (tapPos - currentTranslation) / currentScale;

    // 新しい倍率でのパン量を計算
    final newTranslation = tapPos - focalBefore * targetScale;

    // Matrix4 を更新
    setState(() {
      _transformController.value = Matrix4.identity()
        ..translate(newTranslation.dx, newTranslation.dy)
        ..scale(targetScale);
    });
  }

  Future<void> _pickCircleImage(int circleId) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final newImage = FileImage(File(pickedFile.path));
      await viewModel.updateCircleImage(circleId, newImage.file.path);
    }
  }

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(mapDetailViewModelProvider(widget.mapId).notifier);
    _transformController.addListener(_onTransformChanged);
    _currentScale = _transformController.value.getMaxScaleOnAxis();
  }

  @override
  void dispose() {
    _transformController.removeListener(_onTransformChanged);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_orientationLocked) {
      final orientation = MediaQuery.of(context).orientation;

      if (orientation == Orientation.portrait) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }

      _orientationLocked = true;
    }
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
                    onLongPressStart: (details) => _onLongPressStart(
                      context,
                      details,
                      imageDisplaySize,
                      value.baseImageSize,
                    ),
                    onDoubleTapDown: (details) =>
                        _handleDoubleTap(details.localPosition),
                    child: InteractiveViewer(
                      transformationController: _transformController,
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
                              key: Key(circle.circleId.toString()),
                              opacity:
                                  selectedCircleId == null ||
                                      selectedCircleId == circle.circleId
                                  ? 1.0
                                  : 0.5,
                              child: Stack(
                                children: [
                                  DraggableLine(
                                    startPixelX:
                                        circle.positionX! +
                                        circle.sizeWidth! ~/ 2,
                                    startPixelY:
                                        circle.positionY! +
                                        circle.sizeHeight! ~/ 2,
                                    endPixelX: circle.pointerX!,
                                    endPixelY: circle.pointerY!,
                                    imageOriginalSize: value.baseImageSize,
                                    imageDisplaySize: imageDisplaySize,
                                    dragIconScale: _transformController.value
                                        .getMaxScaleOnAxis(),
                                    showIcon:
                                        selectedCircleId == circle.circleId,
                                    onEndPointDragEnd: (newEndX, newEndY) {
                                      viewModel.updateCirclePointer(
                                        circle.circleId!,
                                        newEndX,
                                        newEndY,
                                      );
                                    },
                                  ),
                                  PixelPositioned(
                                    pixelX: circle.positionX!,
                                    pixelY: circle.positionY!,
                                    imageDisplaySize: imageDisplaySize,
                                    imageOriginalSize: value.baseImageSize,
                                    onTap: () => _onCircleTap(context, circle),
                                    onDragEnd: (x, y) async {
                                      await viewModel.updateCirclePosition(
                                        circle.circleId!,
                                        x,
                                        y,
                                      );
                                    },
                                    child: Container(
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
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
                                            onLongPress: () {
                                              _pickCircleImage(
                                                circle.circleId!,
                                              );
                                            },
                                          ),
                                          if (circle.circleName != null)
                                            SizedBox(
                                              width:
                                                  circle.sizeWidth! *
                                                  (imageDisplaySize.width /
                                                      value
                                                          .baseImageSize
                                                          .width),
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
                                                      value
                                                          .baseImageSize
                                                          .width),
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
                                                      value
                                                          .baseImageSize
                                                          .width),
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
