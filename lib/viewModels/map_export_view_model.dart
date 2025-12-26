import 'package:circle_marker/repositories/map_export_repository.dart';
import 'package:circle_marker/states/map_export_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'map_export_view_model.g.dart';

@riverpod
class MapExportViewModel extends _$MapExportViewModel {
  @override
  MapExportState build() {
    return const MapExportState();
  }

  Future<void> exportMap(int mapId) async {
    state = state.copyWith(isExporting: true, errorMessage: null);

    try {
      final repository = ref.read(mapExportRepositoryProvider);
      final filePath = await repository.exportMap(mapId);

      state = state.copyWith(
        isExporting: false,
        exportedFilePath: filePath,
      );
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        errorMessage: 'エクスポート失敗: $e',
      );
    }
  }

  Future<void> importMap(String filePath) async {
    state = state.copyWith(isImporting: true, errorMessage: null);

    try {
      final repository = ref.read(mapExportRepositoryProvider);
      await repository.importMap(filePath);

      state = state.copyWith(isImporting: false);

      // マップ詳細画面に遷移（ナビゲーション処理は UI 側で）
      // UI側でimportMapの戻り値を使って遷移処理を実装する
    } catch (e) {
      state = state.copyWith(
        isImporting: false,
        errorMessage: 'インポート失敗: $e',
      );
    }
  }

  Future<void> shareExportedMap(String filePath) async {
    await Share.shareXFiles([XFile(filePath)]);
  }

  void clearExportedFilePath() {
    state = state.copyWith(exportedFilePath: null);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
