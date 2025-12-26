import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_export_state.freezed.dart';

@freezed
class MapExportState with _$MapExportState {
  const factory MapExportState({
    @Default(false) bool isExporting,
    @Default(false) bool isImporting,
    String? errorMessage,
    String? exportedFilePath,
  }) = _MapExportState;
}
