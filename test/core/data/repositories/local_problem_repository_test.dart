import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odab_ddokddok/core/data/datasources/local/app_database.dart' as db;
import 'package:odab_ddokddok/core/data/repositories/local_problem_repository.dart';
import 'package:odab_ddokddok/core/domain/entities/problem.dart' as domain;
import 'package:odab_ddokddok/core/domain/entities/review_schedule.dart';
import 'package:odab_ddokddok/core/services/srs/sm2_srs_service.dart';

void main() {
  group('LocalProblemRepository', () {
    late db.AppDatabase database;
    late LocalProblemRepository repository;

    setUp(() {
      database = db.AppDatabase.forTesting(NativeDatabase.memory());
      repository = LocalProblemRepository(
        database: database,
        srsService: Sm2SrsService(),
      );
    });

    tearDown(() async {
      await database.close();
    });

    test('save persists problem and returns it with same id', () async {
      final DateTime now = DateTime.utc(2026, 6, 13, 9);
      final domain.Problem problem = domain.Problem(
        id: 'test-1',
        originalImagePath: '/img/test-1.jpg',
        subject: domain.Subject.math,
        tags: const <String>['미적분'],
        wrongCount: 0,
        createdAt: now,
        nextReviewAt: now.add(const Duration(days: 1)),
        schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
        syncStatus: domain.SyncStatus.local,
      );

      final domain.Problem saved = await repository.save(problem);

      expect(saved.id, 'test-1');
      expect(saved.subject, domain.Subject.math);
    });

    test('findById returns saved problem or null', () async {
      final DateTime now = DateTime.utc(2026, 6, 13, 9);
      final domain.Problem problem = domain.Problem(
        id: 'test-2',
        originalImagePath: '/img/test-2.jpg',
        subject: domain.Subject.english,
        tags: const <String>['독해'],
        wrongCount: 0,
        createdAt: now,
        nextReviewAt: now.add(const Duration(days: 1)),
        schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
        syncStatus: domain.SyncStatus.local,
      );

      await repository.save(problem);

      final domain.Problem? found = await repository.findById('test-2');
      expect(found, isNotNull);
      expect(found?.subject, domain.Subject.english);

      final domain.Problem? notFound = await repository.findById('nonexistent');
      expect(notFound, isNull);
    });

    test('incrementWrongCount increases count', () async {
      final DateTime now = DateTime.utc(2026, 6, 13, 9);
      final domain.Problem problem = domain.Problem(
        id: 'inc-1',
        originalImagePath: '/img/inc1.jpg',
        subject: domain.Subject.math,
        tags: const <String>[],
        wrongCount: 0,
        createdAt: now,
        nextReviewAt: now.add(const Duration(days: 1)),
        schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
        syncStatus: domain.SyncStatus.local,
      );

      await repository.save(problem);
      await repository.incrementWrongCount('inc-1');

      final domain.Problem? updated = await repository.findById('inc-1');
      expect(updated?.wrongCount, 1);
    });

    test('delete removes problem', () async {
      final DateTime now = DateTime.utc(2026, 6, 13, 9);
      final domain.Problem problem = domain.Problem(
        id: 'del-1',
        originalImagePath: '/img/del1.jpg',
        subject: domain.Subject.math,
        tags: const <String>[],
        wrongCount: 0,
        createdAt: now,
        nextReviewAt: now.add(const Duration(days: 1)),
        schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
        syncStatus: domain.SyncStatus.local,
      );

      await repository.save(problem);
      await repository.delete('del-1');

      final domain.Problem? found = await repository.findById('del-1');
      expect(found, isNull);
    });

    test('watchBySubject emits filtered problems', () async {
      final DateTime now = DateTime.utc(2026, 6, 13, 9);
      final domain.Problem math1 = domain.Problem(
        id: 'math-1',
        originalImagePath: '/img/m1.jpg',
        subject: domain.Subject.math,
        tags: const <String>[],
        wrongCount: 0,
        createdAt: now,
        nextReviewAt: now.add(const Duration(days: 1)),
        schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
        syncStatus: domain.SyncStatus.local,
      );

      final domain.Problem eng1 = domain.Problem(
        id: 'eng-1',
        originalImagePath: '/img/e1.jpg',
        subject: domain.Subject.english,
        tags: const <String>[],
        wrongCount: 0,
        createdAt: now,
        nextReviewAt: now.add(const Duration(days: 1)),
        schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
        syncStatus: domain.SyncStatus.local,
      );

      await repository.save(math1);
      await repository.save(eng1);

      final List<domain.Problem> mathProblems = await repository.watchBySubject(domain.Subject.math).first;

      expect(mathProblems, isNotEmpty);
      expect(mathProblems.every((domain.Problem p) => p.subject == domain.Subject.math), isTrue);
    });

    test('applyReviewResult updates schedule based on result', () async {
      final DateTime now = DateTime.utc(2026, 6, 13, 9);
      final domain.Problem problem = domain.Problem(
        id: 'rev-1',
        originalImagePath: '/img/rev1.jpg',
        subject: domain.Subject.math,
        tags: const <String>[],
        wrongCount: 0,
        createdAt: now,
        nextReviewAt: now.add(const Duration(days: 1)),
        schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
        syncStatus: domain.SyncStatus.local,
      );

      await repository.save(problem);
      await repository.applyReviewResult('rev-1', ReviewResult.good);

      final domain.Problem? updated = await repository.findById('rev-1');
      expect(updated?.schedule.repetitions, 1);
      expect(updated?.schedule.intervalDays, 1);
    });
  });
}
