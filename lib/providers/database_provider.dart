import 'package:circle_marker/database_helper.dart';
import 'package:circle_marker/exceptions/app_exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database_provider.g.dart';

/// データベースインスタンスを提供するプロバイダー
@riverpod
Future<sqflite.Database> database(Ref ref) async {
  try {
    return await DatabaseHelper.instance.database;
  } on sqflite.DatabaseException catch (e) {
    debugPrint('Database provider error: $e');
    throw DatabaseException('Database provider error', e);
  }
}
