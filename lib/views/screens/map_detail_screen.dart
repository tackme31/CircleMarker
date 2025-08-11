import 'dart:io';

import 'package:circle_marker/viewModels/map_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class MapDetailScreen extends ConsumerStatefulWidget {
  const MapDetailScreen({super.key, required this.mapId});

  final int mapId;

  @override
  ConsumerState<MapDetailScreen> createState() => _MapDetailScreenState();
}

class _MapDetailScreenState extends ConsumerState<MapDetailScreen> {
  File? _baseImage;
  final TransformationController _controller = TransformationController();
  Offset? _lastImagePixel;
  Size? _imageOriginalSize;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final decoded = await decodeImageFromList(await file.readAsBytes());
      setState(() {
        _baseImage = file;
        _imageOriginalSize = Size(
          decoded.width.toDouble(),
          decoded.height.toDouble(),
        );
        _lastImagePixel = Offset.zero;
      });
    }
  }

  void _onDoubleTap(
    BuildContext context,
    TapDownDetails details,
    Size stackSize,
  ) {
    if (_imageOriginalSize == null) {
      return;
    }

    // Stack内でfit: BoxFit.containで画像が表示されるサイズを計算
    final imageAspect = _imageOriginalSize!.width / _imageOriginalSize!.height;
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
    final imgX = imageLocal.dx * (_imageOriginalSize!.width / displayWidth);
    final imgY = imageLocal.dy * (_imageOriginalSize!.height / displayHeight);

    setState(() {
      _lastImagePixel = Offset(imgX, imgY);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapDetailViewModelProvider(widget.mapId));

    return Scaffold(
      appBar: AppBar(
        title: switch (state) {
          AsyncData(:final value) when value.mapDetail?.title != null => Text(
            //value.mapDetail!.title!,
            _lastImagePixel != null
                ? '${value.mapDetail!.title!} (${_lastImagePixel!.dx.toStringAsFixed(1)}, ${_lastImagePixel!.dy.toStringAsFixed(1)})'
                : value.mapDetail!.title!,
          ),
          AsyncError() => const Text('Error'),
          _ => const Text('No title'),
        },
        actions: [IconButton(icon: const Text('画像を選択'), onPressed: _pickImage)],
      ),
      body: switch (state) {
        AsyncData(:final value) => Container(
          child: Column(
            children: [
              if (_baseImage != null && _imageOriginalSize != null)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Stackの表示サイズ
                      final imageDisplaySize = Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );
                      return GestureDetector(
                        onDoubleTapDown: (details) =>
                            _onDoubleTap(context, details, imageDisplaySize),
                        child: InteractiveViewer(
                          transformationController: _controller,
                          minScale: 0.5,
                          maxScale: 10.0,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.file(
                                  _baseImage!,
                                  fit: BoxFit.contain,
                                ),
                              ),
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
        ),
        AsyncError(:final error) => Center(
          child: Text('Something went wrong: $error'),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
