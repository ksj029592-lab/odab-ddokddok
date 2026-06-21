import 'package:drift/drift.dart';

part 'app_database.g.dart';

class Problems extends Table {
  TextColumn get id => text()();

  TextColumn get originalImagePath => text().named('original_image_path')();
  TextColumn get processedImagePath => text().named('processed_image_path').nullable()();
  TextColumn get ocrText => text().named('ocr_text').nullable()();
  TextColumn get latex => text().nullable()();
  TextColumn get subject => text()();
  TextColumn get unit => text().nullable()();
  TextColumn get difficulty => text().nullable()();
  IntColumn get wrongCount => integer().named('wrong_count').withDefault(const Constant(0))();
  TextColumn get userNote => text().named('user_note').nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get lastReviewedAt => integer().named('last_reviewed_at').nullable()();
  IntColumn get nextReviewAt => integer().named('next_review_at')();
  IntColumn get intervalDays => integer().named('interval_days')();
  RealColumn get easeFactor => real().named('ease_factor')();
  IntColumn get repetitions => integer()();
  TextColumn get contentHash => text().named('content_hash').nullable()();
  TextColumn get syncStatus => text().named('sync_status').withDefault(const Constant('local'))();

  @override
  Set<Column<Object>>? get primaryKey => <Column<Object>>{id};
}

class Tags extends Table {
  TextColumn get problemId =>
      text().named('problem_id').references(Problems, #id, onDelete: KeyAction.cascade)();
  TextColumn get tag => text()();

  @override
  Set<Column<Object>>? get primaryKey => <Column<Object>>{problemId, tag};
}

@DriftDatabase(tables: <Type>[Problems, Tags])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        beforeOpen: (OpeningDetails details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
