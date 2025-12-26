import 'package:circle_marker/viewModels/circle_list_view_model.dart';
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
            return ListTile(
              title: Text(
                circle.circleName == null || circle.circleName!.isEmpty
                    ? '名前なし'
                    : circle.circleName!,
              ),
              subtitle: Text(
                circle.spaceNo == null || circle.spaceNo!.isEmpty
                    ? 'スペース番号なし'
                    : circle.spaceNo!,
              ),
            );
          },
        ),
        AsyncError(:final error) => Center(child: Text('エラー: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
