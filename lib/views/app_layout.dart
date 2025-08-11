import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppLayout extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) => navigationShell.goBranch(index),
        selectedIndex: navigationShell.currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        height: 60,
        destinations: [
          NavigationDestination(icon: Icon(Icons.map), label: '配置図'),
          NavigationDestination(icon: Icon(Icons.person), label: 'サークル'),
        ],
      ),
    );
  }
}
