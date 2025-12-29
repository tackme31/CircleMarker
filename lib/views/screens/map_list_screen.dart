import 'dart:io';
import 'package:circle_marker/repositories/map_repository.dart';
import 'package:circle_marker/utils/error_handler.dart';
import 'package:circle_marker/utils/map_name_formatter.dart';
import 'package:circle_marker/viewModels/map_export_view_model.dart';
import 'package:circle_marker/viewModels/map_list_view_model.dart';
import 'package:circle_marker/viewModels/markdown_output_view_model.dart';
import 'package:circle_marker/views/widgets/map_export_dialog.dart';
import 'package:circle_marker/views/widgets/multi_select_filter_dialog.dart';
import 'package:file_picker/file_picker.dart';
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
  late final TextEditingController _searchController;
  final _searchFocusNode = FocusNode();

  // 選択モード状態
  final Set<int> _selectedMapIds = {};
  bool get _isSelectionMode => _selectedMapIds.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 選択モードに入る
  void _enterSelectionMode(int mapId) {
    setState(() {
      _selectedMapIds.add(mapId);
    });
  }

  /// マップの選択を切り替え
  void _toggleMapSelection(int mapId) {
    setState(() {
      if (_selectedMapIds.contains(mapId)) {
        _selectedMapIds.remove(mapId);
      } else {
        _selectedMapIds.add(mapId);
      }
    });
  }

  /// 選択をクリア
  void _clearSelection() {
    setState(() {
      _selectedMapIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapListViewModelProvider);
    final ImagePicker picker = ImagePicker();

    return PopScope(
      canPop: !_isSelectionMode,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop && _isSelectionMode) {
          _clearSelection();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: _isSelectionMode
              ? Text('${_selectedMapIds.length}件選択中')
              : Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: TextField(
                    focusNode: _searchFocusNode,
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'マップを検索',
                      prefixIcon: const Icon(Icons.search),
                      prefixIconConstraints: const BoxConstraints(
                        minHeight: 0,
                        minWidth: 0,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : null,
                      suffixIconConstraints: const BoxConstraints(
                        minHeight: 0,
                        minWidth: 0,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 0,
                      ),
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: _onSearchSubmitted,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
          leading: _isSelectionMode
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _clearSelection,
                )
              : null,
          actions: [
            if (!_isSelectionMode) ...[
              state.when(
                data: (data) => IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showEventFilterDialog(context, ref, data),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              IconButton(
                onPressed: _importMap,
                icon: const Icon(Icons.file_upload),
              ),
            ],
          ],
      ),
      body: switch (state) {
        AsyncData(:final value) => Column(
          children: [
            // フィルター状態表示
            if (value.selectedEventNames.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    Chip(
                      label: Text(
                        'フィルター: ${value.selectedEventNames.length}個のイベント',
                      ),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        ref
                            .read(mapListViewModelProvider.notifier)
                            .clearEventFilter();
                      },
                    ),
                  ],
                ),
              ),
            // マップリスト
            Expanded(
              child: value.maps.isEmpty
                  ? _buildEmptySearchResult()
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          final currentQuery = value.searchQuery;
                          await ref
                              .read(mapListViewModelProvider.notifier)
                              .searchMaps(currentQuery);
                        },
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const Gap(12),
                          itemCount: value.maps.length,
                          itemBuilder: (context, index) {
                            final mapWithCount = value.maps[index];
                            final isSelected = _selectedMapIds
                                .contains(mapWithCount.map.mapId);
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              color: isSelected
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : null,
                              child: InkWell(
                                onTap: () async {
                                  if (_isSelectionMode) {
                                    // 選択モード: 選択を切り替え
                                    _toggleMapSelection(
                                        mapWithCount.map.mapId!);
                                  } else {
                                    // 通常モード: 画面遷移
                                    _searchFocusNode.unfocus();

                                    await context.push(
                                      '/mapList/${mapWithCount.map.mapId}',
                                    );
                                    await ref
                                        .read(mapListViewModelProvider.notifier)
                                        .refresh();
                                  }
                                },
                                onLongPress: () {
                                  if (!_isSelectionMode) {
                                    // 選択モードに入る
                                    _enterSelectionMode(
                                        mapWithCount.map.mapId!);
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // サムネイル画像表示
                                    Stack(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: _buildMapThumbnail(
                                            mapWithCount.map,
                                          ),
                                        ),
                                        // 選択インジケーター
                                        if (isSelected)
                                          Positioned(
                                            left: 8,
                                            top: 8,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(8),
                                              child: Icon(
                                                Icons.check,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        // PopupMenuは選択モード中は非表示
                                        if (!_isSelectionMode)
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: PopupMenuButton<String>(
                                              onSelected: (value) async {
                                                switch (value) {
                                                  case 'markdown':
                                                    await _generateMarkdown(
                                                      mapWithCount.map.mapId!,
                                                    );
                                                    break;
                                                  case 'export':
                                                    _showExportDialog(
                                                      mapWithCount.map.mapId!,
                                                    );
                                                    break;
                                                  case 'image':
                                                    await _setImage(
                                                      mapWithCount.map.mapId!,
                                                      picker,
                                                    );
                                                    break;
                                                  case 'delete':
                                                    _deleteMap(
                                                        mapWithCount.map);
                                                    break;
                                                  default:
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                const PopupMenuItem(
                                                  value: 'markdown',
                                                  child: Text('Markdownで出力'),
                                                ),
                                                const PopupMenuItem(
                                                  value: 'export',
                                                  child: Text('エクスポート'),
                                                ),
                                                const PopupMenuItem(
                                                  value: 'image',
                                                  child: Text('画像変更'),
                                                ),
                                                const PopupMenuItem(
                                                  value: 'delete',
                                                  child: Text('削除'),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              buildMapDisplayTitle(
                                                mapWithCount.map.eventName,
                                                mapWithCount.map.title,
                                              ),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.person,
                                                  size: 16,
                                                ),
                                                const Gap(4),
                                                Text(
                                                  '${mapWithCount.circleCount}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
        AsyncError(:final error) => Center(
          child: Text('Something went wrong: $error'),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
      floatingActionButton: _isSelectionMode
          ? FloatingActionButton(
              heroTag: 'batch_export',
              onPressed: _batchExportMarkdown,
              tooltip: '選択したマップをMarkdownで出力',
              child: const Icon(Icons.numbers),
            )
          : FloatingActionButton(
              heroTag: 'add',
              onPressed: () => _addMap(picker),
              child: const Icon(Icons.add),
            ),
      ),
    );
  }

  /// 検索実行時のコールバック
  Future<void> _onSearchSubmitted(String query) async {
    await ref.read(mapListViewModelProvider.notifier).searchMaps(query);
  }

  /// 検索クリア
  void _clearSearch() {
    _searchController.clear();
    ref.read(mapListViewModelProvider.notifier).clearSearch();
  }

  /// 検索結果が0件の場合の表示
  Widget _buildEmptySearchResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '検索結果がありません',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
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
            onPressed: () => context.pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('削除'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final viewModel = ref.read(mapListViewModelProvider.notifier);
      await viewModel.removeMap(map.mapId!);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('マップを削除しました')));

      ref.invalidate(mapListViewModelProvider);
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
      ref.invalidate(mapListViewModelProvider);
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
        child: const Center(child: Icon(Icons.image_not_supported, size: 48)),
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
                child: const Center(child: Icon(Icons.broken_image, size: 48)),
              );
            },
          );
        }
        return Container(
          color: Colors.grey[300],
          child: const Center(child: Icon(Icons.broken_image, size: 48)),
        );
      },
    );
  }

  /// エクスポートダイアログを表示する
  void _showExportDialog(int mapId) {
    showDialog(
      context: context,
      builder: (_) => MapExportDialog(mapId: mapId),
    );
  }

  /// マップをインポートする
  Future<void> _importMap() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['cmzip'],
      );

      if (result == null || result.files.single.path == null) {
        return;
      }

      if (!mounted) return;

      // インポート中のローディング表示
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [CircularProgressIndicator(), Gap(16), Text('インポート中...')],
          ),
        ),
      );

      final viewModel = ref.read(mapExportViewModelProvider.notifier);
      await viewModel.importMap(result.files.single.path!);

      if (!mounted) return;
      context.pop(); // ローディングダイアログを閉じる

      final state = ref.read(mapExportViewModelProvider);
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('インポートが完了しました')));

        // マップリストを更新
        ref.invalidate(mapListViewModelProvider);
      }
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace);

      if (!mounted) return;
      // ローディングダイアログが表示されていれば閉じる
      if (Navigator.of(context).canPop()) {
        context.pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ErrorHandler.getUserFriendlyMessage(error)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  /// Markdown出力を実行する
  Future<void> _generateMarkdown(int mapId) async {
    try {
      await ref
          .read(markdownOutputViewModelProvider.notifier)
          .generateAndShare(mapId);

      // エラー時のスナックバー表示
      final state = ref.read(markdownOutputViewModelProvider);
      if (state.errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
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

  /// 選択したマップをまとめてMarkdown出力
  Future<void> _batchExportMarkdown() async {
    if (_selectedMapIds.isEmpty) return;

    try {
      // ローディングフィードバック
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              Gap(16),
              Text('Markdown生成中...'),
            ],
          ),
          duration: Duration(seconds: 30),
        ),
      );

      await ref
          .read(markdownOutputViewModelProvider.notifier)
          .generateAndShareBatch(_selectedMapIds.toList());

      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      final state = ref.read(markdownOutputViewModelProvider);
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // 成功したら選択をクリア
        _clearSelection();
      }
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace);

      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ErrorHandler.getUserFriendlyMessage(error)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _setImage(int mapId, ImagePicker picker) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile == null) return;

      final viewModel = ref.read(mapListViewModelProvider.notifier);
      await viewModel.updateMapImage(mapId, pickedFile.path);

      ref.invalidate(mapListViewModelProvider);
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace);
      // Handle error appropriately, possibly by showing a snackbar.
    }
  }

  /// イベント名フィルターダイアログを表示
  Future<void> _showEventFilterDialog(
    BuildContext context,
    WidgetRef ref,
    state,
  ) async {
    // イベント名一覧を取得
    final eventNames = await ref
        .read(mapRepositoryProvider)
        .getDistinctEventNames();
    if (!context.mounted) return;

    // 「無題のイベント」を選択肢に追加
    final allEventOptions = ['無題のイベント', ...eventNames];

    await showDialog(
      context: context,
      builder: (context) => MultiSelectFilterDialog<String, String>(
        title: 'イベントでフィルター',
        items: allEventOptions,
        initialSelection: state.selectedEventNames,
        keyExtractor: (eventName) => eventName,
        displayTextBuilder: (eventName) => eventName,
        onApply: (selectedEventNames) async {
          await ref
              .read(mapListViewModelProvider.notifier)
              .setEventFilter(selectedEventNames);
        },
      ),
    );
  }
}
