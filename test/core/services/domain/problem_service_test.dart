import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odab_ddokddok/core/data/datasources/local/app_database.dart';
import 'package:odab_ddokddok/core/data/repositories/local_problem_repository.dart';
import 'package:odab_ddokddok/core/domain/entities/problem.dart' as domain;
import 'package:odab_ddokddok/core/domain/entities/review_schedule.dart';
import 'package:odab_ddokddok/core/services/domain/problem_service.dart';
import 'package:odab_ddokddok/core/services/srs/sm2_srs_service.dart';

void main() {
  group('ProblemService', () {
    late AppDatabase database;
    late LocalProblemRepository repository;
    late ProblemService service;

    setUp(() {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      repository = LocalProblemRepository(
        database: database,
        srsService: Sm2SrsService(),
      );
      service = ProblemService(
        repository: repository,
        srsService: Sm2SrsService(),
      );
    });

    tearDown(() async {
      await database.close();
    });

    test('save delegates to repository', () async {
      final DateTime now = DateTime.utc(2026, 6, 13, 10);
      final domain.Problem problem = domain.Problem(
        id: 'test-1',
        originalImagePath: '/img/test.jpg',
        subject: domain.Subject.math,
        tags: const <String>[],
        wrongCount: 0,
        createdAt: now,
        nextReviewAt: now.add(const Duration(days: 1)),
        schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
        syncStatus: domain.SyncStatus.local,
      );

      final domain.Problem result = await service.save(problem);

      expect(result.id, 'test-1');
      expect(result.subject, domain.Subject.math);
    });

    test('findById retrieves saved problem', () async {
      final DateTime now = DateTime.utc(2026, 6, 13, 10);
      final domain.Problem problem = domain.Problem(
        id: 'find-1',
        originalImagePath: '/img/find.jpg',
        subject: domain.Subject.english,
        tags: const <String>[],
        wrongCount: 1,
        createdAt: now,
        nextReviewAt: now.add(const Duration(days: 2)),
        schedule: const ReviewSchedule(intervalDays: 2, easeFactor: 2.5, repetitions: 1),
        syncStatus: domain.SyncStatus.local,
      );

      await service.save(problem);
      final domain.Problem? result = await service.findById('find-1');

      expect(result, isNotNull);
      expect(result?.id, 'find-1');
      expect(result?.subject, domain.Subject.english);
    });

    test('getBySubject returns stream of filtered problems', () async {
      final DateTime now = DateTime.utc(2026, 6, 13, 10);
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

      await service.save(math1);
      await service.save(eng1);

      final List<domain.Problem> result = await service.getBySubject(domain.Subject.math).first;

      expect(result, isNotEmpty);
      expect(result.every((domain.Problem p) => p.subject == domain.Subject.math), isTrue);
    });

    test('getDueForReview returns stream of due problems', () async {
      final DateTime now = DateTime.utc(2026, 6, 13, 10);
      final domain.Problem due1 = domain.Problem(
        id: 'due-1',
        originalImagePath: '/img/due1.jpg',
        subject: domain.Subject.math,
        tags: const <String>[],
        wrongCount: 1,
        createdAt: now.subtract(const Duration(days: 7)),
        nextReviewAt: now.subtract(const Duration(hours: 1)),
        schedule: const ReviewSchedule(intervalDays: 7, easeFactor: 2.5, repetitions: 1),
        syncStatus: domain.SyncStatus.local,
      );

      await service.save(due1);
      final List<domain.Problem> result = await service.getDueForReview(now).first;

      expect(result, isNotEmpty);
      expect(result.first.id, 'due-1');
    });

    test('reviewProblem applies SM-2 algorithm', () async {
      final DateTime now = DateTime.utc(2026, 6, 13, 10);
      final domain.Problem problem = domain.Problem(
        id: 'review-1',
        originalImagePath: '/img/rev.jpg',
        subject: domain.Subject.math,
        tags: const <String>[],
        wrongCount: 0,
        createdAt: now,
        nextReviewAt: now.add(const Duration(days: 1)),
        schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
        syncStatus: domain.SyncStatus.local,
      );

      await service.save(problem);
      await service.reviewProblem('review-1', ReviewResult.good);

      final domain.Problem? updated = await service.findById('review-1');
      expect(updated?.schedule.repetitions, 1);
    });

    test('incrementWrongCount increases count', () async {
      final DateTime now = DateTime.utc(2026, 6, 13, 10);
      final domain.Problem problem = domain.Problem(
        id: 'inc-1',
        originalImagePath: '/img/inc.jpg',
        subject: domain.Subject.math,
        tags: const <String>[],
        wrongCount: 0,
        createdAt: now,
        nextReviewAt: now.add(const Duration(days: 1)),
        schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
        syncStatus: domain.SyncStatus.local,
      );

      await service.save(problem);
      await service.incrementWrongCount('inc-1');

      final domain.Problem? updated = await service.findById('inc-1');
      expect(updated?.wrongCount, 1);
    });

    test('deleteProblem removes problem', () async {
      final DateTime now = DateTime.utc(2026, 6, 13, 10);
      final domain.Problem problem = domain.Problem(
        id: 'del-1',
        originalImagePath: '/img/del.jpg',
        subject: domain.Subject.math,
        tags: const <String>[],
        wrongCount: 0,
        createdAt: now,
        nextReviewAt: now.add(const Duration(days: 1)),
        schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
        syncStatus: domain.SyncStatus.local,
      );

      await service.save(problem);
      await service.deleteProblem('del-1');

      final domain.Problem? result = await service.findById('del-1');
      expect(result, isNull);
    });
  });
}
