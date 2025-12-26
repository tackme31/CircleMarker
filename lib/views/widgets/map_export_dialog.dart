import 'package:circle_marker/viewModels/map_export_view_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MapExportDialog extends ConsumerWidget {
  const MapExportDialog({required this.mapId, super.key});

  final int mapId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(mapExportViewModelProvider);

    return AlertDialog(
      title: const Text('マップエクスポート'),
      content: viewModel.isExporting
          ? const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Gap(16),
                Text('エクスポート中...'),
              ],
            )
          : viewModel.errorMessage != null
          ? Text(viewModel.errorMessage!)
          : const Text('このマップをエクスポートしますか？'),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('キャンセル')),
        if (!viewModel.isExporting && viewModel.exportedFilePath == null)
          TextButton(
            onPressed: () async {
              await ref
                  .read(mapExportViewModelProvider.notifier)
                  .exportMap(mapId);
              final updatedState = ref.read(mapExportViewModelProvider);
              if (updatedState.exportedFilePath != null) {
                await ref
                    .read(mapExportViewModelProvider.notifier)
                    .shareExportedMap(updatedState.exportedFilePath!);
                if (context.mounted) {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('エクスポートが完了しました')),
                  );
                }
              }
            },
            child: const Text('エクスポート'),
          ),
      ],
    );
  }
}
