import 'package:odab_ddokddok/core/domain/entities/problem.dart';
import 'package:odab_ddokddok/core/domain/entities/review_schedule.dart';

abstract class ProblemRepository {
  Future<Problem> save(Problem problem);

  Future<Problem?> findById(String id);

  Stream<List<Problem>> watchBySubject(Subject subject);

  Stream<List<Problem>> watchDueForReview(DateTime now);

  Future<void> applyReviewResult(String id, ReviewResult result);

  Future<void> incrementWrongCount(String id);

  Future<void> delete(String id);
}
