import 'package:circle_marker/repositories/markdown_output_repository.dart';
import 'package:circle_marker/states/markdown_output_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'markdown_output_view_model.g.dart';

@riverpod
class MarkdownOutputViewModel extends _$MarkdownOutputViewModel {
  @override
  MarkdownOutputState build() {
    return const MarkdownOutputState();
  }

  Future<void> generateAndShare(int mapId) async {
    state = state.copyWith(isGenerating: true, errorMessage: null);

    try {
      final repository = ref.read(markdownOutputRepositoryProvider);
      final markdown = await repository.generateMarkdown(mapId);

      // 共有
      await Share.share(markdown, subject: 'サークル一覧');

      state = state.copyWith(isGenerating: false);
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        errorMessage: 'Markdown出力失敗: $e',
      );
    }
  }
}
