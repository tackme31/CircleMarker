import 'package:freezed_annotation/freezed_annotation.dart';

part 'markdown_output_state.freezed.dart';

@freezed
class MarkdownOutputState with _$MarkdownOutputState {
  const factory MarkdownOutputState({
    @Default(false) bool isGenerating,
    String? errorMessage,
  }) = _MarkdownOutputState;
}
