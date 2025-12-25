/// アプリケーション共通の例外クラス
class AppException implements Exception {
  AppException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() =>
      'AppException: $message${cause != null ? '\nCaused by: $cause' : ''}';
}

/// 画像操作に関する例外
class ImageOperationException extends AppException {
  ImageOperationException(super.message, [super.cause]);
}

/// データベース操作に関する例外
class DatabaseException extends AppException {
  DatabaseException(super.message, [super.cause]);
}

/// ファイル操作に関する例外
class FileOperationException extends AppException {
  FileOperationException(super.message, [super.cause]);
}
