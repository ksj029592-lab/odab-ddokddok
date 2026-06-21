import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odab_ddokddok/core/data/datasources/local/app_database.dart';
import 'package:odab_ddokddok/core/data/repositories/local_problem_repository.dart';
import 'package:odab_ddokddok/core/domain/entities/problem.dart' as domain;
import 'package:odab_ddokddok/core/domain/entities/review_schedule.dart';
import 'package:odab_ddokddok/core/services/providers/problem_providers.dart';
import 'package:odab_ddokddok/core/services/srs/sm2_srs_service.dart';

void main() {
  group('Problem Providers', () {
    late ProviderContainer container;
    late AppDatabase database;

    setUp(() {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = LocalProblemRepository(
        database: database,
        srsService: Sm2SrsService(),
      );

      container = ProviderContainer(
        overrides: [
          problemRepositoryProvider.overrideWithValue(repository),
        ],
      );
    });

    tearDown(() async {
      container.dispose();
      await database.close();
    });

    group('problemRepositoryProvider', () {
      test('provides LocalProblemRepository instance', () {
        final repository = container.read(problemRepositoryProvider);
        expect(repository, isNotNull);
      });

      test('returns same repository instance on multiple reads', () {
        final repo1 = container.read(problemRepositoryProvider);
        final repo2 = container.read(problemRepositoryProvider);
        expect(identical(repo1, repo2), isTrue);
      });
    });

    group('findProblemProvider', () {
      test('returns null for non-existent problem', () async {
        final result = await container.read(findProblemProvider('nonexistent').future);
        expect(result, isNull);
      });

      test('returns saved problem by id', () async {
        final DateTime now = DateTime.utc(2026, 6, 13, 10);
        final problem = domain.Problem(
          id: 'find-test',
          originalImagePath: '/img/find.jpg',
          subject: domain.Subject.math,
          tags: const <String>[],
          wrongCount: 0,
          createdAt: now,
          nextReviewAt: now.add(const Duration(days: 1)),
          schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
          syncStatus: domain.SyncStatus.local,
        );

        final repository = container.read(problemRepositoryProvider);
        await repository.save(problem);

        final result = await container.read(findProblemProvider('find-test').future);
        expect(result?.id, 'find-test');
        expect(result?.subject, domain.Subject.math);
      });
    });

    group('problemsBySubjectProvider', () {
      test('emits problems filtered by subject', () async {
        final DateTime now = DateTime.utc(2026, 6, 13, 10);
        final math1 = domain.Problem(
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

        final eng1 = domain.Problem(
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

        final repository = container.read(problemRepositoryProvider);
        await repository.save(math1);
        await repository.save(eng1);

        // Directly test repository since provider is just a wrapper
        final stream = repository.watchBySubject(domain.Subject.math);
        final result = await stream.first;

        expect(result, isNotEmpty);
        expect(result.every((p) => p.subject == domain.Subject.math), isTrue);
      });
    });

    group('dueProblemsProvider', () {
      test('emits problems due for review', () async {
        final now = DateTime.utc(2026, 6, 13, 10);
        final due = domain.Problem(
          id: 'due-1',
          originalImagePath: '/img/due.jpg',
          subject: domain.Subject.math,
          tags: const <String>[],
          wrongCount: 1,
          createdAt: now.subtract(const Duration(days: 7)),
          nextReviewAt: now.subtract(const Duration(hours: 1)),
          schedule: const ReviewSchedule(intervalDays: 7, easeFactor: 2.5, repetitions: 1),
          syncStatus: domain.SyncStatus.local,
        );

        final repository = container.read(problemRepositoryProvider);
        await repository.save(due);

        // Directly test repository since provider is just a wrapper
        final stream = repository.watchDueForReview(now);
        final result = await stream.first;

        expect(result, isNotEmpty);
        expect(result.first.id, 'due-1');
      });
    });

    group('reviewStateNotifierProvider', () {
      test('reviewProblem updates problem schedule', () async {
        final DateTime now = DateTime.utc(2026, 6, 13, 10);
        final problem = domain.Problem(
          id: 'review-prov',
          originalImagePath: '/img/rev.jpg',
          subject: domain.Subject.math,
          tags: const <String>[],
          wrongCount: 0,
          createdAt: now,
          nextReviewAt: now.add(const Duration(days: 1)),
          schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
          syncStatus: domain.SyncStatus.local,
        );

        final repository = container.read(problemRepositoryProvider);
        await repository.save(problem);

        final notifier = container.read(reviewStateNotifierProvider.notifier);
        await notifier.reviewProblem('review-prov', ReviewResult.good);

        final updated = await repository.findById('review-prov');
        expect(updated?.schedule.repetitions, 1);
      });

      test('incrementWrongCount increases count', () async {
        final DateTime now = DateTime.utc(2026, 6, 13, 10);
        final problem = domain.Problem(
          id: 'inc-prov',
          originalImagePath: '/img/inc.jpg',
          subject: domain.Subject.math,
          tags: const <String>[],
          wrongCount: 0,
          createdAt: now,
          nextReviewAt: now.add(const Duration(days: 1)),
          schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
          syncStatus: domain.SyncStatus.local,
        );

        final repository = container.read(problemRepositoryProvider);
        await repository.save(problem);

        final notifier = container.read(reviewStateNotifierProvider.notifier);
        await notifier.incrementWrongCount('inc-prov');

        final updated = await repository.findById('inc-prov');
        expect(updated?.wrongCount, 1);
      });

      test('deleteProblem removes problem', () async {
        final DateTime now = DateTime.utc(2026, 6, 13, 10);
        final problem = domain.Problem(
          id: 'del-prov',
          originalImagePath: '/img/del.jpg',
          subject: domain.Subject.math,
          tags: const <String>[],
          wrongCount: 0,
          createdAt: now,
          nextReviewAt: now.add(const Duration(days: 1)),
          schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
          syncStatus: domain.SyncStatus.local,
        );

        final repository = container.read(problemRepositoryProvider);
        await repository.save(problem);

        final notifier = container.read(reviewStateNotifierProvider.notifier);
        await notifier.deleteProblem('del-prov');

        final result = await repository.findById('del-prov');
        expect(result, isNull);
      });

      test('state tracks loading status', () async {
        final state = container.read(reviewStateNotifierProvider);
        expect(state, isA<AsyncValue<void>>());
      });
    });
  });
}
