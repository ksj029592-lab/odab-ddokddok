import 'package:odab_ddokddok/core/domain/entities/review_schedule.dart';
import 'package:odab_ddokddok/core/services/srs/srs_service.dart';

/// Simplified SM-2 schedule policy for v1 MVP.
///
/// Notes:
/// - again: EF - 0.2 (canonical SM-2 is more punitive)
/// - hard: EF - 0.15
/// - good: EF unchanged
/// - easy: EF + 0.1 and interval bonus x1.3
///
/// This keeps early review failures from over-penalizing the learner while
/// preserving the 1 -> 6 -> n*EF progression for successful reviews.
class Sm2SrsService implements SrsService {
  static const double _minEaseFactor = 1.3;

  @override
  ReviewSchedule initialSchedule() {
    return const ReviewSchedule(
      intervalDays: 1,
      easeFactor: 2.5,
      repetitions: 0,
    );
  }

  @override
  ReviewSchedule nextSchedule(ReviewSchedule current, ReviewResult result) {
    switch (result) {
      case ReviewResult.again:
        return ReviewSchedule(
          intervalDays: 1,
          easeFactor: _clampEase(current.easeFactor - 0.2),
          repetitions: 0,
        );
      case ReviewResult.hard:
        return ReviewSchedule(
          intervalDays: _atLeastOne((current.intervalDays * 1.2).round()),
          easeFactor: _clampEase(current.easeFactor - 0.15),
          repetitions: current.repetitions,
        );
      case ReviewResult.good:
        final int nextInterval = _nextGoodInterval(current);
        return ReviewSchedule(
          intervalDays: _atLeastOne(nextInterval),
          easeFactor: _clampEase(current.easeFactor),
          repetitions: current.repetitions + 1,
        );
      case ReviewResult.easy:
        final int nextInterval = (_nextGoodInterval(current) * 1.3).round();
        return ReviewSchedule(
          intervalDays: _atLeastOne(nextInterval),
          easeFactor: _clampEase(current.easeFactor + 0.1),
          repetitions: current.repetitions + 1,
        );
    }
  }

  @override
  DateTime calculateNextReview(ReviewSchedule schedule, DateTime now) {
    return now.add(Duration(days: schedule.intervalDays));
  }

  int _nextGoodInterval(ReviewSchedule current) {
    if (current.repetitions == 0) {
      return 1;
    }
    if (current.repetitions == 1) {
      return 6;
    }
    return (current.intervalDays * current.easeFactor).round();
  }

  double _clampEase(double value) {
    return value < _minEaseFactor ? _minEaseFactor : value;
  }

  int _atLeastOne(int value) {
    return value < 1 ? 1 : value;
  }
}
