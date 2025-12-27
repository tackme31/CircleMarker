import 'package:circle_marker/views/app_layout.dart';
import 'package:circle_marker/views/screens/circle_list_screen.dart';
import 'package:circle_marker/views/screens/map_detail_screen.dart';
import 'package:circle_marker/views/screens/map_list_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "app_router.g.dart";

final _rootNavigationKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _mapListNavigationKey = GlobalKey<NavigatorState>(debugLabel: 'mapList');
final _circleListNavigationKey = GlobalKey<NavigatorState>(
  debugLabel: 'circleList',
);

@riverpod
class AppRouter extends _$AppRouter {
  @override
  GoRouter build() {
    return GoRouter(
      navigatorKey: _rootNavigationKey,
      debugLogDiagnostics: kDebugMode,
      initialLocation: '/mapList',
      routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AppLayout(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _mapListNavigationKey,
              routes: [
                GoRoute(
                  path: '/mapList',
                  builder: (context, state) {
                    return const MapListScreen();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _circleListNavigationKey,
              routes: [
                GoRoute(
                  path: '/circleList',
                  builder: (context, state) {
                    return const CircleListScreen();
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/mapList/:mapId',
          pageBuilder: (context, state) {
            final mapId = state.pathParameters['mapId'];
            if (mapId == null) {
              return const MaterialPage(child: SizedBox.shrink());
            }

            // Get circleId from query parameters
            final circleIdStr = state.uri.queryParameters['circleId'];
            final circleId = circleIdStr != null
                ? int.tryParse(circleIdStr)
                : null;

            return MaterialPage(
              child: MapDetailScreen(
                mapId: int.parse(mapId),
                initialSelectedCircleId: circleId,
              ),
            );
          },
        ),
      ],
    );
  }
}
