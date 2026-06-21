enum ReviewResult { again, hard, good, easy }

class ReviewSchedule {
  const ReviewSchedule({
    required this.intervalDays,
    required this.easeFactor,
    required this.repetitions,
  });

  final int intervalDays;
  final double easeFactor;
  final int repetitions;

  ReviewSchedule copyWith({
    int? intervalDays,
    double? easeFactor,
    int? repetitions,
  }) {
    return ReviewSchedule(
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      repetitions: repetitions ?? this.repetitions,
    );
  }
}
