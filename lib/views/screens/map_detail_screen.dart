import 'package:circle_marker/viewModels/map_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MapDetailScreen extends ConsumerWidget {
  const MapDetailScreen({super.key, required this.mapId});

  final int mapId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mapDetailViewModelProvider(mapId));

    return Scaffold(
      appBar: AppBar(
        title: switch (state) {
          AsyncData(:final value) when value.mapDetail?.title != null => Text(
            value.mapDetail!.title!,
          ),
          AsyncError() => const Text('Error'),
          _ => const Text('No title'), // ローディング時など
        },
      ),
      body: switch (state) {
        AsyncData(:final value) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text('data'),
        ),
        AsyncError(:final error) => Center(
          child: Text('Something went wrong: $error'),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
