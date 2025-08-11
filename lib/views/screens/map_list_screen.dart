import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MapListScreen extends ConsumerWidget {
  const MapListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('配置図'),
      ),
      body: Center(
        child: Column(
        ),
      )
    );
  }
}
