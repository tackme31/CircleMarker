import 'package:circle_marker/repositories/map_repository.dart';
import 'package:circle_marker/states/circle_list_state.dart';
import 'package:circle_marker/viewModels/circle_list_view_model.dart';
import 'package:circle_marker/views/widgets/circle_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CircleListScreen extends ConsumerWidget {
  const CircleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(circleListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('サークル'),
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
              child: ListView.builder(
                itemCount: value.circles.length,
                itemBuilder: (context, index) {
                  final circle = value.circles[index].circle;
                  final mapName = value.circles[index].mapTitle ?? 'マップ名なし';
                  final circleName =
                      circle.circleName == null || circle.circleName!.isEmpty
                      ? '名前なし'
                      : circle.circleName!;
                  return ListTile(
                    title: Text("[$mapName] $circleName"),
                    subtitle: Text(
                      circle.spaceNo == null || circle.spaceNo!.isEmpty
                          ? 'スペース番号なし'
                          : circle.spaceNo!,
                    ),
                    onTap: circle.mapId != null && circle.circleId != null
                        ? () async {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => CircleBottomSheet(
                                circle.mapId!,
                                circle.circleId,
                                circleId: circle.circleId!,
                                width: 0.8,
                                height: 0.7,
                                isDeletable: false,
                              ),
                            );
                          }
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
        AsyncError(:final error) => Center(child: Text('エラー: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Future<void> _showMapFilterDialog(
    BuildContext context,
    WidgetRef ref,
    CircleListState state,
  ) async {
    final maps = await ref.read(mapRepositoryProvider).getMapDetails();
    if (!context.mounted) return;

    final selectedMapIds = List<int>.from(state.selectedMapIds);

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('配置図でフィルター'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: const Text('すべて選択'),
                    value: selectedMapIds.isEmpty,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedMapIds.clear();
                        } else {
                          selectedMapIds.clear();
                          selectedMapIds.addAll(
                            maps
                                .where((m) => m.mapId != null)
                                .map((m) => m.mapId!)
                                .toList(),
                          );
                        }
                      });
                    },
                  ),
                  const Divider(),
                  ...maps.where((m) => m.mapId != null).map((map) {
                    final isSelected = selectedMapIds.contains(map.mapId!);
                    return CheckboxListTile(
                      title: Text(map.title ?? 'マップ名なし'),
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedMapIds.add(map.mapId!);
                          } else {
                            selectedMapIds.remove(map.mapId!);
                          }
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await ref
                      .read(circleListViewModelProvider.notifier)
                      .setMapFilter(selectedMapIds);
                },
                child: const Text('適用'),
              ),
            ],
          );
        },
      ),
    );
  }
}
