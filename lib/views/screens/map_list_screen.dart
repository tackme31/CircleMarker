import 'dart:io';
import 'package:circle_marker/utils/error_handler.dart';
import 'package:circle_marker/viewModels/map_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class MapListScreen extends ConsumerStatefulWidget {
  const MapListScreen({super.key});

  @override
  ConsumerState<MapListScreen> createState() => _MapListScreenState();
}

class _MapListScreenState extends ConsumerState<MapListScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapListViewModelProvider);
    final viewModel = ref.watch(mapListViewModelProvider.notifier);
    final ImagePicker picker = ImagePicker();

    return Scaffold(
      appBar: AppBar(title: const Text('配置図')),
      body: switch (state) {
        AsyncData(:final value) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView.separated(
            separatorBuilder: (context, index) => const Gap(12),
            itemCount: value.maps.length,
            itemBuilder: (context, index) {
              final map = value.maps[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () async {
                    await context.push('/mapList/${map.mapId}');
                    viewModel.refreshMaps();
                  },
                  onLongPress: () {
                    _deleteMap(map);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // サムネイル画像表示
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: _buildMapThumbnail(map),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          map.title ?? 'No title',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        AsyncError(:final error) => Center(
          child: Text('Something went wrong: $error'),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMap(picker),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// マップを削除する
  Future<void> _deleteMap(map) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('確認'),
        content: Text('「${map.title}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('削除'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final viewModel = ref.read(mapListViewModelProvider.notifier);
      await viewModel.removeMap(map.mapId!);
      await viewModel.refreshMaps();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('マップを削除しました')),
      );
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ErrorHandler.getUserFriendlyMessage(error)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  /// マップを追加する
  Future<void> _addMap(ImagePicker picker) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile == null) return;

      final viewModel = ref.read(mapListViewModelProvider.notifier);
      final imagePath = pickedFile.path;
      final map = await viewModel.addMapDetail(imagePath);

      if (!mounted) return;
      await context.push('/mapList/${map.mapId}', extra: map);
      viewModel.refreshMaps();
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ErrorHandler.getUserFriendlyMessage(error)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  /// マップのサムネイル画像を表示するウィジェット
  Widget _buildMapThumbnail(map) {
    // サムネイルパスが存在する場合はサムネイルを表示
    final imagePath = map.thumbnailPath ?? map.baseImagePath;

    if (imagePath == null) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 48),
        ),
      );
    }

    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      cacheWidth: 512, // メモリキャッシュサイズ制限
      errorBuilder: (context, error, stackTrace) {
        // サムネイル読み込み失敗時は元画像を縮小して表示
        if (map.baseImagePath != null && imagePath != map.baseImagePath) {
          return Image.file(
            File(map.baseImagePath!),
            fit: BoxFit.cover,
            cacheWidth: 512,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.broken_image, size: 48),
                ),
              );
            },
          );
        }
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.broken_image, size: 48),
          ),
        );
      },
    );
  }
}
