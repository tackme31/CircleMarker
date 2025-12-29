import 'dart:io';

import 'package:circle_marker/models/circle_detail.dart';
import 'package:circle_marker/utils/map_name_formatter.dart';
import 'package:flutter/material.dart';

/// サークルリストアイテムウィジェット
///
/// CircleListScreenで使用する、モダンなデザインのリストアイテム。
/// 丸い画像サムネイル、完了フラグバッジ、サークル情報を表示します。
class CircleListItem extends StatelessWidget {
  const CircleListItem({
    super.key,
    required this.circle,
    required this.mapTitle,
    required this.eventName,
    required this.onTap,
    required this.onNavigateToMap,
  });

  final CircleDetail circle;
  final String? mapTitle;
  final String? eventName;
  final VoidCallback onTap;
  final VoidCallback onNavigateToMap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildCircleThumbnail(),
      title: _buildTitle(),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(buildMapDisplayTitle(eventName, mapTitle)),
          Text(circle.spaceNo ?? 'No Space'),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.location_pin),
        onPressed: onNavigateToMap,
        tooltip: 'マップで表示',
      ),
      onTap: onTap,
    );
  }

  /// サークルサムネイル（CircleAvatar + isDoneBadge）
  Widget _buildCircleThumbnail() {
    return Stack(
      children: [
        CircleAvatar(radius: 26, backgroundImage: _getImageProvider()),
        if (circle.isDone == 1)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 12, color: Colors.white),
            ),
          ),
      ],
    );
  }

  /// 画像プロバイダを取得
  ///
  /// imagePathが存在する場合はFileImageを返し、
  /// 存在しない場合はno_image.pngを返します。
  ImageProvider _getImageProvider() {
    if (circle.imagePath != null && circle.imagePath!.isNotEmpty) {
      final file = File(circle.imagePath!);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }
    return const AssetImage('assets/no_image.png');
  }

  /// タイトル（サークル名）
  Widget _buildTitle() {
    return Text(
      circle.circleName?.isNotEmpty == true ? circle.circleName! : '名前なし',
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
