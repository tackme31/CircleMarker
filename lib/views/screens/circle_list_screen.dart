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
        AsyncData(:final value) => ListView.builder(
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
                      // リスト更新
                      ref.invalidate(circleListViewModelProvider);
                    }
                  : null,
            );
          },
        ),
        AsyncError(:final error) => Center(child: Text('エラー: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
