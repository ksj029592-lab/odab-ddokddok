import 'package:flutter_test/flutter_test.dart';
import 'package:odab_ddokddok/core/domain/entities/review_schedule.dart';
import 'package:odab_ddokddok/core/services/srs/sm2_srs_service.dart';

void main() {
  group('Sm2SrsService', () {
    final Sm2SrsService service = Sm2SrsService();

    test('initialSchedule starts with interval=1, ef=2.5, repetitions=0', () {
      final ReviewSchedule schedule = service.initialSchedule();

      expect(schedule.intervalDays, 1);
      expect(schedule.easeFactor, 2.5);
      expect(schedule.repetitions, 0);
    });

    test('again resets interval and repetitions and decreases ef', () {
      const ReviewSchedule current = ReviewSchedule(
        intervalDays: 7,
        easeFactor: 2.5,
        repetitions: 3,
      );

      final ReviewSchedule next = service.nextSchedule(current, ReviewResult.again);

      expect(next.intervalDays, 1);
      expect(next.easeFactor, 2.3);
      expect(next.repetitions, 0);
    });

    test('again keeps ef at minimum 1.3', () {
      const ReviewSchedule current = ReviewSchedule(
        intervalDays: 7,
        easeFactor: 1.3,
        repetitions: 3,
      );

      final ReviewSchedule next = service.nextSchedule(current, ReviewResult.again);

      expect(next.easeFactor, 1.3);
    });

    test('hard grows interval by x1.2 and decreases ef', () {
      const ReviewSchedule current = ReviewSchedule(
        intervalDays: 10,
        easeFactor: 2.5,
        repetitions: 2,
      );

      final ReviewSchedule next = service.nextSchedule(current, ReviewResult.hard);

      expect(next.intervalDays, 12);
      expect(next.easeFactor, 2.35);
      expect(next.repetitions, 2);
    });

    test('hard rounds interval x1.2 for fractional values', () {
      const ReviewSchedule current = ReviewSchedule(
        intervalDays: 7,
        easeFactor: 2.5,
        repetitions: 2,
      );

      final ReviewSchedule next = service.nextSchedule(current, ReviewResult.hard);

      expect(next.intervalDays, 8);
    });

    test('good on first success keeps interval 1 and repetitions +1', () {
      const ReviewSchedule current = ReviewSchedule(
        intervalDays: 1,
        easeFactor: 2.5,
        repetitions: 0,
      );

      final ReviewSchedule next = service.nextSchedule(current, ReviewResult.good);

      expect(next.intervalDays, 1);
      expect(next.repetitions, 1);
    });

    test('good on second success sets interval to 6', () {
      const ReviewSchedule current = ReviewSchedule(
        intervalDays: 1,
        easeFactor: 2.5,
        repetitions: 1,
      );

      final ReviewSchedule next = service.nextSchedule(current, ReviewResult.good);

      expect(next.intervalDays, 6);
      expect(next.repetitions, 2);
    });

    test('good after second success uses interval * ef', () {
      const ReviewSchedule current = ReviewSchedule(
        intervalDays: 6,
        easeFactor: 2.5,
        repetitions: 2,
      );

      final ReviewSchedule next = service.nextSchedule(current, ReviewResult.good);

      expect(next.intervalDays, 15);
      expect(next.repetitions, 3);
    });

    test('easy applies bonus and increases ef by 0.1', () {
      const ReviewSchedule current = ReviewSchedule(
        intervalDays: 6,
        easeFactor: 2.5,
        repetitions: 2,
      );

      final ReviewSchedule next = service.nextSchedule(current, ReviewResult.easy);

      expect(next.intervalDays, 20);
      expect(next.easeFactor, 2.6);
      expect(next.repetitions, 3);
    });

    test('easy on first repetition keeps minimum interval after rounding', () {
      const ReviewSchedule current = ReviewSchedule(
        intervalDays: 1,
        easeFactor: 2.5,
        repetitions: 0,
      );

      final ReviewSchedule next = service.nextSchedule(current, ReviewResult.easy);

      expect(next.intervalDays, 1);
      expect(next.easeFactor, 2.6);
      expect(next.repetitions, 1);
    });

    test('calculateNextReview adds interval days', () {
      const ReviewSchedule schedule = ReviewSchedule(
        intervalDays: 6,
        easeFactor: 2.5,
        repetitions: 2,
      );
      final DateTime now = DateTime.utc(2026, 6, 13, 8);

      final DateTime next = service.calculateNextReview(schedule, now);

      expect(next, DateTime.utc(2026, 6, 19, 8));
    });

    test('calculateNextReview preserves local time-of-day', () {
      const ReviewSchedule schedule = ReviewSchedule(
        intervalDays: 1,
        easeFactor: 2.5,
        repetitions: 0,
      );
      final DateTime now = DateTime(2026, 11, 1, 12, 0);

      final DateTime next = service.calculateNextReview(schedule, now);

      expect(next.hour, 12);
      expect(next.day, 2);
    });
  });
}
