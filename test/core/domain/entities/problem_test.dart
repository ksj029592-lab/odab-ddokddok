import 'package:flutter_test/flutter_test.dart';
import 'package:odab_ddokddok/core/domain/entities/problem.dart';
import 'package:odab_ddokddok/core/domain/entities/review_schedule.dart';

void main() {
  test('creates Problem with required fields and defaults', () {
    final DateTime now = DateTime.utc(2026, 6, 13, 9);

    final Problem problem = Problem(
      id: 'p1',
      originalImagePath: '/images/p1.jpg',
      subject: Subject.math,
      tags: const <String>['미적분'],
      wrongCount: 0,
      createdAt: now,
      nextReviewAt: now.add(const Duration(days: 1)),
      schedule: const ReviewSchedule(intervalDays: 1, easeFactor: 2.5, repetitions: 0),
      syncStatus: SyncStatus.local,
    );

    expect(problem.id, 'p1');
    expect(problem.subject, Subject.math);
    expect(problem.tags, contains('미적분'));
    expect(problem.syncStatus, SyncStatus.local);
  });

  test('copyWith updates selected fields only', () {
    final DateTime now = DateTime.utc(2026, 6, 13, 9);

    final Problem original = Problem(
      id: 'p2',
      originalImagePath: '/images/p2.jpg',
      subject: Subject.english,
      tags: const <String>['독해'],
      wrongCount: 1,
      createdAt: now,
      nextReviewAt: now.add(const Duration(days: 2)),
      schedule: const ReviewSchedule(intervalDays: 2, easeFactor: 2.4, repetitions: 1),
      syncStatus: SyncStatus.local,
    );

    final Problem updated = original.copyWith(
      wrongCount: 2,
      syncStatus: SyncStatus.pending,
    );

    expect(updated.id, original.id);
    expect(updated.wrongCount, 2);
    expect(updated.syncStatus, SyncStatus.pending);
    expect(updated.subject, Subject.english);
  });
}
