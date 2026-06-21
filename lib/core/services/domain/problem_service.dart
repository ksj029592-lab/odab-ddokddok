import 'package:odab_ddokddok/core/domain/entities/problem.dart';
import 'package:odab_ddokddok/core/domain/entities/review_schedule.dart';
import 'package:odab_ddokddok/core/domain/repositories/problem_repository.dart';
import 'package:odab_ddokddok/core/services/srs/srs_service.dart';

/// 문제 도메인 비즈니스 로직 서비스
/// 
/// 저장소와 SRS 서비스를 조율하여 문제 관리의 비즈니스 로직을 제공합니다.
class ProblemService {
  const ProblemService({
    required this.repository,
    required this.srsService,
  });

  final ProblemRepository repository;
  final SrsService srsService;

  /// 문제 저장 (생성 또는 업데이트)
  Future<Problem> save(Problem problem) async {
    return repository.save(problem);
  }

  /// ID로 문제 조회
  Future<Problem?> findById(String id) async {
    return repository.findById(id);
  }

  /// 과목별 문제 스트림 조회
  Stream<List<Problem>> getBySubject(Subject subject) {
    return repository.watchBySubject(subject);
  }

  /// 복습 대기중인 문제 스트림 조회
  Stream<List<Problem>> getDueForReview(DateTime now) {
    return repository.watchDueForReview(now);
  }

  /// 복습 결과 적용 (SM-2 알고리즘 적용)
  Future<void> reviewProblem(String id, ReviewResult result) async {
    return repository.applyReviewResult(id, result);
  }

  /// 오답 횟수 증가
  Future<void> incrementWrongCount(String id) async {
    return repository.incrementWrongCount(id);
  }

  /// 문제 삭제
  Future<void> deleteProblem(String id) async {
    return repository.delete(id);
  }
}
