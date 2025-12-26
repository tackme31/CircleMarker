import 'package:circle_marker/exceptions/app_exceptions.dart';
import 'package:circle_marker/utils/error_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorHandler', () {
    group('getUserFriendlyMessage', () {
      test('returns appropriate message for DatabaseException', () {
        final error = DatabaseException('Connection failed');
        final message = ErrorHandler.getUserFriendlyMessage(error);

        expect(message, 'データベースエラーが発生しました。アプリを再起動してください。');
      });

      test('returns appropriate message for ImageOperationException', () {
        final error = ImageOperationException('Compression failed');
        final message = ErrorHandler.getUserFriendlyMessage(error);

        expect(message, '画像の処理に失敗しました。もう一度お試しください。');
      });

      test('returns appropriate message for FileOperationException', () {
        final error = FileOperationException('Write failed');
        final message = ErrorHandler.getUserFriendlyMessage(error);

        expect(message, 'ファイル操作に失敗しました。ストレージの空き容量を確認してください。');
      });

      test('returns appropriate message for generic AppException', () {
        final error = AppException('Something went wrong');
        final message = ErrorHandler.getUserFriendlyMessage(error);

        expect(message, 'Something went wrong');
      });

      test('returns generic message for unknown exceptions', () {
        final error = Exception('Unknown error');
        final message = ErrorHandler.getUserFriendlyMessage(error);

        expect(message, '予期しないエラーが発生しました。');
      });

      test('returns generic message for non-exception errors', () {
        const error = 'String error';
        final message = ErrorHandler.getUserFriendlyMessage(error);

        expect(message, '予期しないエラーが発生しました。');
      });
    });
  });
}
