import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/repositories/map_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'markdown_output_repository.g.dart';

@Riverpod(keepAlive: true)
MarkdownOutputRepository markdownOutputRepository(Ref ref) {
  return MarkdownOutputRepository(
    mapRepository: ref.watch(mapRepositoryProvider),
    circleRepository: ref.watch(circleRepositoryProvider),
  );
}

class MarkdownOutputRepository {
  MarkdownOutputRepository({
    required this.mapRepository,
    required this.circleRepository,
  });

  final MapRepository mapRepository;
  final CircleRepository circleRepository;

  Future<String> generateMarkdown(int mapId) async {
    // 1. データ取得
    final mapDetail = await mapRepository.getMapDetail(mapId);
    final circles = await circleRepository.getCircles(mapId);

    // SpaceNoの昇順でソート
    final sortedCircles = [...circles]
      ..sort((a, b) {
        final spaceA = a.spaceNo ?? '';
        final spaceB = b.spaceNo ?? '';
        return spaceA.compareTo(spaceB);
      });

    // 2. Markdown 生成
    final buffer = StringBuffer();

    // マップタイトル
    buffer.writeln('## ${mapDetail.title}');

    // 各サークル
    for (final circle in sortedCircles) {
      // サークル名とスペース番号
      buffer.writeln('### ${circle.circleName} (${circle.spaceNo})');

      // description（空でない場合のみ出力）
      final description = circle.description ?? '';
      if (description.isNotEmpty) {
        buffer.writeln(description);
      }

      // descriptionとnoteの両方が存在する場合のみ空行を挿入
      final note = circle.note ?? '';
      if (description.isNotEmpty && note.isNotEmpty) {
        buffer.writeln();
      }

      // note（空でない場合のみ出力）
      if (note.isNotEmpty) {
        buffer.writeln(note);
      }

      // サークル間の空行（最後のサークルでも出力）
      buffer.writeln();
    }

    return buffer.toString();
  }
}
