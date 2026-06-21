import 'package:odab_ddokddok/core/domain/entities/review_schedule.dart';

abstract class SrsService {
  ReviewSchedule initialSchedule();

  ReviewSchedule nextSchedule(
    ReviewSchedule current,
    ReviewResult result,
  );

  DateTime calculateNextReview(
    ReviewSchedule schedule,
    DateTime now,
  );
}
