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
      appBar: AppBar(title: const Text('サークル')),
      body: switch (state) {
        AsyncData(:final value) => ListView.builder(
          itemCount: value.circles.length,
          itemBuilder: (context, index) {
            final circle = value.circles[index];
            final mapName = circle.mapId != null
                ? value.mapNames[circle.mapId] ?? 'マップ不明'
                : 'マップ不明';
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
