import 'package:circle_marker/exceptions/app_exceptions.dart';
import 'package:flutter/foundation.dart';

/// グローバルエラーハンドラー
class ErrorHandler {
  /// エラーをログに記録し、必要に応じて外部サービスに送信する
  static void handleError(Object error, StackTrace stackTrace) {
    debugPrint('Error occurred: $error');
    debugPrint('Stack trace: $stackTrace');

    // 本番環境では Crashlytics などに送信
    // if (kReleaseMode) {
    //   FirebaseCrashlytics.instance.recordError(error, stackTrace);
    // }
  }

  /// エラーをユーザーにわかりやすいメッセージに変換する
  static String getUserFriendlyMessage(Object error) {
    if (error is DatabaseException) {
      return 'データベースエラーが発生しました。アプリを再起動してください。';
    } else if (error is ImageOperationException) {
      return '画像の処理に失敗しました。もう一度お試しください。';
    } else if (error is FileOperationException) {
      return 'ファイル操作に失敗しました。ストレージの空き容量を確認してください。';
    } else if (error is AppException) {
      // 一般的な AppException
      return error.message;
    } else {
      return '予期しないエラーが発生しました。';
    }
  }
}
