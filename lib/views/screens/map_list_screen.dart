import 'package:circle_marker/viewModels/map_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MapListScreen extends ConsumerWidget {
  const MapListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mapListViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('配置図')),
      body: switch (state) {
        AsyncData(:final value) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView.separated(
            separatorBuilder: (context, index) => const Gap(12),
            itemCount: value.maps.length,
            itemBuilder: (_, index) {
              final map = value.maps[index];
              return ListTile(
                title: Text(map.title ?? 'No title'),
                onTap: () {
                  context.push('/mapList/${map.mapId}');
                },
              );
            },
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
