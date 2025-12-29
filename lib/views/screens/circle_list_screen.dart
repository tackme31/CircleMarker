import 'package:circle_marker/repositories/map_repository.dart';
import 'package:circle_marker/states/circle_list_state.dart';
import 'package:circle_marker/utils/enums.dart';
import 'package:circle_marker/utils/map_name_formatter.dart';
import 'package:circle_marker/viewModels/circle_list_view_model.dart';
import 'package:circle_marker/views/widgets/circle_bottom_sheet.dart';
import 'package:circle_marker/views/widgets/circle_list_item.dart';
import 'package:circle_marker/views/widgets/empty_search_result.dart';
import 'package:circle_marker/views/widgets/multi_select_filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CircleListScreen extends ConsumerStatefulWidget {
  const CircleListScreen({super.key});

  @override
  ConsumerState<CircleListScreen> createState() => _CircleListScreenState();
}

class _CircleListScreenState extends ConsumerState<CircleListScreen> {
  late final TextEditingController _searchController;
  final _searchFocusNode = FocusNode();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(circleListViewModelProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(circleListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: 'サークルを検索',
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
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: InputBorder.none,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: _onSearchSubmitted,
            onChanged: (value) {
              setState(() {}); // Update clear button visibility
            },
          ),
        ),
        actions: [
          state.when(
            data: (data) => IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showMapFilterDialog(context, ref, data),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          state.when(
            data: (data) => PopupMenuButton<String>(
              icon: const Icon(Icons.sort),
              onSelected: (value) async {
                final parts = value.split('_');
                final sortType = parts[0] == 'mapName'
                    ? SortType.mapName
                    : SortType.spaceNo;
                final sortDirection = parts[1] == 'asc'
                    ? SortDirection.asc
                    : SortDirection.desc;

                await ref
                    .read(circleListViewModelProvider.notifier)
                    .setSort(sortType, sortDirection);
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'mapName_asc',
                  child: Row(
                    children: [
                      if (state.value?.sortType == SortType.mapName &&
                          state.value?.sortDirection == SortDirection.asc)
                        const Icon(Icons.check, size: 16)
                      else
                        const SizedBox(width: 16),
                      const SizedBox(width: 8),
                      const Text('マップ名（昇順）'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'mapName_desc',
                  child: Row(
                    children: [
                      if (state.value?.sortType == SortType.mapName &&
                          state.value?.sortDirection == SortDirection.desc)
                        const Icon(Icons.check, size: 16)
                      else
                        const SizedBox(width: 16),
                      const SizedBox(width: 8),
                      const Text('マップ名（降順）'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'spaceNo_asc',
                  child: Row(
                    children: [
                      if (state.value?.sortType == SortType.spaceNo &&
                          state.value?.sortDirection == SortDirection.asc)
                        const Icon(Icons.check, size: 16)
                      else
                        const SizedBox(width: 16),
                      const SizedBox(width: 8),
                      const Text('スペース番号（昇順）'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'spaceNo_desc',
                  child: Row(
                    children: [
                      if (state.value?.sortType == SortType.spaceNo &&
                          state.value?.sortDirection == SortDirection.desc)
                        const Icon(Icons.check, size: 16)
                      else
                        const SizedBox(width: 16),
                      const SizedBox(width: 8),
                      const Text('スペース番号（降順）'),
                    ],
                  ),
                ),
              ],
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: switch (state) {
        AsyncData(:final value) => Column(
          children: [
            if (value.selectedMapIds.isNotEmpty)
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
                      label: Text('フィルター: ${value.selectedMapIds.length}個の配置図'),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        ref
                            .read(circleListViewModelProvider.notifier)
                            .setMapFilter([]);
                      },
                    ),
                  ],
                ),
              ),
            Expanded(
              child: value.circles.isEmpty
                  ? const EmptySearchResult()
                  : RefreshIndicator(
                      onRefresh: () async {
                        ref
                            .read(circleListViewModelProvider.notifier)
                            .refresh();
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            value.circles.length +
                            (value.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Show loading indicator at the bottom
                          if (index == value.circles.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final circleWithMap = value.circles[index];
                          final circle = circleWithMap.circle;
                          final mapTitle = circleWithMap.mapTitle;
                          final eventName = circleWithMap.eventName;

                          return CircleListItem(
                            circle: circle,
                            mapTitle: mapTitle,
                            eventName: eventName,
                            onTap: () async {
                              _searchFocusNode.unfocus();

                              if (circle.mapId == null ||
                                  circle.circleId == null) {
                                return;
                              }

                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => CircleBottomSheet(
                                  circle.mapId!,
                                  circle.circleId,
                                  circleId: circle.circleId!,
                                  width: 0.8,
                                  height: 0.7,
                                  onDelete: (circleId) => ref
                                      .read(
                                        circleListViewModelProvider.notifier,
                                      )
                                      .removeCircle(circleId),
                                ),
                              );

                              ref
                                  .read(circleListViewModelProvider.notifier)
                                  .refresh();
                            },
                            onNavigateToMap: () {
                              if (circle.mapId != null &&
                                  circle.circleId != null) {
                                context.push(
                                  '/mapList/${circle.mapId}?circleId=${circle.circleId}',
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
        AsyncError(:final error) => Center(child: Text('エラー: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  /// 検索実行時のコールバック
  Future<void> _onSearchSubmitted(String query) async {
    await ref.read(circleListViewModelProvider.notifier).searchCircles(query);
  }

  /// 検索クリア
  void _clearSearch() {
    _searchController.clear();
    ref.read(circleListViewModelProvider.notifier).clearSearch();
  }

  Future<void> _showMapFilterDialog(
    BuildContext context,
    WidgetRef ref,
    CircleListState state,
  ) async {
    final maps = await ref.read(mapRepositoryProvider).getMapDetails();
    if (!context.mounted) return;

    // mapIdがnullでないマップのみをフィルター
    final validMaps = maps.where((m) => m.mapId != null).toList();

    await showDialog(
      context: context,
      builder: (context) => MultiSelectFilterDialog(
        title: '配置図でフィルター',
        items: validMaps,
        initialSelection: state.selectedMapIds,
        keyExtractor: (map) => map.mapId!,
        displayTextBuilder: (map) =>
            buildMapDisplayTitle(map.eventName, map.title),
        onApply: (selectedMapIds) async {
          await ref
              .read(circleListViewModelProvider.notifier)
              .setMapFilter(selectedMapIds);
        },
      ),
    );
  }
}
