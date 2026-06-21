import 'package:drift/drift.dart' as drift;
import 'package:odab_ddokddok/core/data/datasources/local/app_database.dart' as db;
import 'package:odab_ddokddok/core/data/mappers/problem_mapper.dart';
import 'package:odab_ddokddok/core/domain/entities/problem.dart' as domain;
import 'package:odab_ddokddok/core/domain/entities/review_schedule.dart';
import 'package:odab_ddokddok/core/domain/repositories/problem_repository.dart';
import 'package:odab_ddokddok/core/services/srs/srs_service.dart';

class LocalProblemRepository implements ProblemRepository {
  const LocalProblemRepository({
    required this.database,
    required this.srsService,
  });

  final db.AppDatabase database;
  final SrsService srsService;

  @override
  Future<domain.Problem> save(domain.Problem problem) async {
    final db.ProblemsCompanion companion = ProblemMapper.toCompanion(problem);
    await database.into(database.problems).insertOnConflictUpdate(companion);
    return problem;
  }

  @override
  Future<domain.Problem?> findById(String id) async {
    final db.Problem? row = await (database.select(database.problems)
          ..where((p) => p.id.equals(id)))
        .getSingleOrNull();

    if (row == null) return null;

    return ProblemMapper.toDomain(row);
  }

  @override
  Stream<List<domain.Problem>> watchBySubject(domain.Subject subject) {
    final String subjectStr = _subjectToString(subject);

    return (database.select(database.problems)
          ..where((p) => p.subject.equals(subjectStr)))
        .watch()
        .asyncMap((List<db.Problem> rows) async {
      return rows.map((db.Problem row) => ProblemMapper.toDomain(row)).toList();
    });
  }

  @override
  Stream<List<domain.Problem>> watchDueForReview(DateTime now) {
    return (database.select(database.problems)
          ..where((p) =>
              p.nextReviewAt.isSmallerOrEqualValue(now.millisecondsSinceEpoch)))
        .watch()
        .asyncMap((List<db.Problem> rows) async {
      return rows.map((db.Problem row) => ProblemMapper.toDomain(row)).toList();
    });
  }

  @override
  Future<void> applyReviewResult(String id, ReviewResult result) async {
    final domain.Problem? current = await findById(id);
    if (current == null) return;

    final ReviewSchedule next =
        srsService.nextSchedule(current.schedule, result);
    final DateTime nextReviewAt =
        srsService.calculateNextReview(next, DateTime.now());

    await (database.update(database.problems)..where((p) => p.id.equals(id)))
        .write(
      db.ProblemsCompanion(
        intervalDays: drift.Value<int>(next.intervalDays),
        easeFactor: drift.Value<double>(next.easeFactor),
        repetitions: drift.Value<int>(next.repetitions),
        nextReviewAt:
            drift.Value<int>(nextReviewAt.millisecondsSinceEpoch),
        lastReviewedAt: drift.Value<int>(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  @override
  Future<void> incrementWrongCount(String id) async {
    await database.transaction(() async {
      final domain.Problem? current = await findById(id);
      if (current == null) return;

      await (database.update(database.problems)..where((p) => p.id.equals(id)))
          .write(
        db.ProblemsCompanion(
          wrongCount: drift.Value<int>(current.wrongCount + 1),
        ),
      );
    });
  }

  @override
  Future<void> delete(String id) async {
    await (database.delete(database.problems)..where((p) => p.id.equals(id)))
        .go();
  }

  /// Subject 열거형을 DB 문자열로 변환 (watchBySubject 헬퍼)
  String _subjectToString(domain.Subject subject) {
    switch (subject) {
      case domain.Subject.korean:
        return 'korean';
      case domain.Subject.english:
        return 'english';
      case domain.Subject.math:
        return 'math';
      case domain.Subject.social:
        return 'social';
      case domain.Subject.science:
        return 'science';
    }
  }
}
