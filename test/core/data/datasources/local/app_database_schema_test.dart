import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odab_ddokddok/core/data/datasources/local/app_database.dart';

void main() {
  group('AppDatabase schema', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      await database.close();
    });

    test('creates problems and tags tables', () async {
      final rows = await database.customSelect(
        "SELECT name FROM sqlite_master WHERE type = 'table'",
      ).get();

      final Set<String> tableNames = Set<String>.from(
        rows.map((row) => row.read<String>('name')),
      );

      expect(tableNames.contains('problems'), isTrue);
      expect(tableNames.contains('tags'), isTrue);
    });

    test('applies defaults for wrong_count and sync_status', () async {
      await database.customStatement(
        'INSERT INTO problems '
        '(id, original_image_path, subject, created_at, next_review_at, '
        'interval_days, ease_factor, repetitions) '
        "VALUES ('p1', '/img/p1.jpg', 'math', 1710000000, 1710003600, 1, 2.5, 0)",
      );

      final rows = await database.customSelect(
        "SELECT wrong_count, sync_status FROM problems WHERE id = 'p1'",
      ).get();

      expect(rows, hasLength(1));
      expect(rows.first.read<int>('wrong_count'), 0);
      expect(rows.first.read<String>('sync_status'), 'local');
    });

    test('deletes related tags when problem is deleted', () async {
      await database.customStatement(
        'INSERT INTO problems '
        '(id, original_image_path, subject, created_at, next_review_at, '
        'interval_days, ease_factor, repetitions) '
        "VALUES ('p2', '/img/p2.jpg', 'english', 1710000000, 1710003600, 1, 2.5, 0)",
      );

      await database.customStatement(
        "INSERT INTO tags (problem_id, tag) VALUES ('p2', 'grammar')",
      );

      await database.customStatement("DELETE FROM problems WHERE id = 'p2'");

      final rows = await database.customSelect(
        "SELECT tag FROM tags WHERE problem_id = 'p2'",
      ).get();

      expect(rows, isEmpty);
    });
  });
}
