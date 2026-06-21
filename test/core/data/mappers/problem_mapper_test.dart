import 'package:flutter_test/flutter_test.dart';
import 'package:odab_ddokddok/core/data/datasources/local/app_database.dart' as db;
import 'package:odab_ddokddok/core/data/mappers/problem_mapper.dart';
import 'package:odab_ddokddok/core/domain/entities/problem.dart' as domain;
import 'package:odab_ddokddok/core/domain/entities/review_schedule.dart';

void main() {
  group('ProblemMapper', () {
    test('toDomain converts Drift row to domain entity', () {
      final DateTime now = DateTime.utc(2026, 6, 13, 10);
      final db.Problem row = db.Problem(
        id: 'test-1',
        originalImagePath: '/img/test.jpg',
        processedImagePath: '/img/processed.jpg',
        ocrText: 'integral sin x dx',
        latex: r'\int \sin x \, dx',
        subject: 'math',
        unit: 'Calculus',
        difficulty: 'hard',
        wrongCount: 2,
        userNote: 'Remember by parts',
        createdAt: now.millisecondsSinceEpoch,
        lastReviewedAt: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
        nextReviewAt: now.add(const Duration(days: 3)).millisecondsSinceEpoch,
        intervalDays: 3,
        easeFactor: 2.3,
        repetitions: 2,
        contentHash: 'abc123',
        syncStatus: 'local',
      );

      final domain.Problem result = ProblemMapper.toDomain(row);

      expect(result.id, 'test-1');
      expect(result.subject, domain.Subject.math);
      expect(result.difficulty, domain.Difficulty.hard);
      expect(result.syncStatus, domain.SyncStatus.local);
      expect(result.wrongCount, 2);
      expect(result.schedule.intervalDays, 3);
      expect(result.schedule.easeFactor, 2.3);
    });

    test('toCompanion converts domain entity to Drift companion', () {
      final DateTime now = DateTime.utc(2026, 6, 13, 10);
      final domain.Problem problem = domain.Problem(
        id: 'test-2',
        originalImagePath: '/img/test2.jpg',
        subject: domain.Subject.english,
        tags: const <String>[],
        wrongCount: 1,
        createdAt: now,
        nextReviewAt: now.add(const Duration(days: 1)),
        schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
        syncStatus: domain.SyncStatus.local,
      );

      final db.ProblemsCompanion result = ProblemMapper.toCompanion(problem);

      expect(result.id.present, isTrue);
      expect(result.id.value, 'test-2');
      expect(result.subject.present, isTrue);
      expect(result.subject.value, 'english');
      expect(result.syncStatus.present, isTrue);
      expect(result.syncStatus.value, 'local');
      expect(result.wrongCount.value, 1);
    });

    test('roundtrip: toDomain(toCompanion) preserves data (except embedding)', () {
      final DateTime now = DateTime.utc(2026, 6, 13, 10);
      final domain.Problem original = domain.Problem(
        id: 'round-1',
        originalImagePath: '/img/orig.jpg',
        ocrText: '2x + 3 = 7',
        subject: domain.Subject.math,
        tags: const <String>['algebra'],
        wrongCount: 3,
        createdAt: now,
        nextReviewAt: now.add(const Duration(days: 7)),
        schedule: const ReviewSchedule(intervalDays: 6, easeFactor: 2.4, repetitions: 3),
        syncStatus: domain.SyncStatus.synced,
        difficulty: domain.Difficulty.easy,
      );

      final db.ProblemsCompanion companion = ProblemMapper.toCompanion(original);
      // Simulate creating a Drift row from companion (stripped of tags for this test)
      final db.Problem reconstructedRow = db.Problem(
        id: companion.id.value,
        originalImagePath: companion.originalImagePath.value,
        processedImagePath: companion.processedImagePath.value,
        ocrText: companion.ocrText.value,
        latex: companion.latex.value,
        subject: companion.subject.value,
        unit: companion.unit.value,
        difficulty: companion.difficulty.value,
        wrongCount: companion.wrongCount.value,
        userNote: companion.userNote.value,
        createdAt: companion.createdAt.value,
        lastReviewedAt: companion.lastReviewedAt.value,
        nextReviewAt: companion.nextReviewAt.value,
        intervalDays: companion.intervalDays.value,
        easeFactor: companion.easeFactor.value,
        repetitions: companion.repetitions.value,
        contentHash: companion.contentHash.value,
        syncStatus: companion.syncStatus.value,
      );

      final domain.Problem reconstructed = ProblemMapper.toDomain(reconstructedRow);

      expect(reconstructed.id, original.id);
      expect(reconstructed.originalImagePath, original.originalImagePath);
      expect(reconstructed.ocrText, original.ocrText);
      expect(reconstructed.subject, original.subject);
      expect(reconstructed.wrongCount, original.wrongCount);
      expect(reconstructed.schedule.intervalDays, original.schedule.intervalDays);
      expect(reconstructed.schedule.easeFactor, original.schedule.easeFactor);
      expect(reconstructed.syncStatus, original.syncStatus);
      expect(reconstructed.difficulty, original.difficulty);
    });

    test('toDomain handles nullable fields correctly', () {
      final DateTime now = DateTime.utc(2026, 6, 13, 10);
      final db.Problem row = db.Problem(
        id: 'sparse-1',
        originalImagePath: '/img/sparse.jpg',
        processedImagePath: null,
        ocrText: null,
        latex: null,
        subject: 'science',
        unit: null,
        difficulty: null,
        wrongCount: 0,
        userNote: null,
        createdAt: now.millisecondsSinceEpoch,
        lastReviewedAt: null,
        nextReviewAt: now.add(const Duration(days: 1)).millisecondsSinceEpoch,
        intervalDays: 1,
        easeFactor: 2.5,
        repetitions: 0,
        contentHash: null,
        syncStatus: 'local',
      );

      final domain.Problem result = ProblemMapper.toDomain(row);

      expect(result.processedImagePath, isNull);
      expect(result.ocrText, isNull);
      expect(result.latex, isNull);
      expect(result.unit, isNull);
      expect(result.difficulty, isNull);
      expect(result.userNote, isNull);
      expect(result.lastReviewedAt, isNull);
      expect(result.contentHash, isNull);
    });
  });
}
