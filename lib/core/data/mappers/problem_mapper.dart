import 'package:drift/drift.dart' as drift;
import 'package:odab_ddokddok/core/data/datasources/local/app_database.dart' as db;
import 'package:odab_ddokddok/core/domain/entities/problem.dart' as domain;
import 'package:odab_ddokddok/core/domain/entities/review_schedule.dart';

/// Drift 데이터 행(ProblemsData)과 도메인 엔티티(Problem) 간 양방향 변환
class ProblemMapper {
  ProblemMapper._(); // 정적 메서드만 제공하는 유틸리티 클래스

  /// Drift 데이터 모델 → 도메인 엔티티
  static domain.Problem toDomain(db.Problem row) {
    return domain.Problem(
      id: row.id,
      originalImagePath: row.originalImagePath,
      processedImagePath: row.processedImagePath,
      ocrText: row.ocrText,
      latex: row.latex,
      subject: _parseSubject(row.subject),
      unit: row.unit,
      tags: const <String>[],
      difficulty: row.difficulty != null ? _parseDifficulty(row.difficulty!) : null,
      wrongCount: row.wrongCount,
      userNote: row.userNote,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      lastReviewedAt: row.lastReviewedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(row.lastReviewedAt!)
          : null,
      nextReviewAt: DateTime.fromMillisecondsSinceEpoch(row.nextReviewAt),
      schedule: ReviewSchedule(
        intervalDays: row.intervalDays,
        easeFactor: row.easeFactor,
        repetitions: row.repetitions,
      ),
      contentHash: row.contentHash,
      embedding: const <double>[],
      syncStatus: _parseSyncStatus(row.syncStatus),
    );
  }

  /// 도메인 엔티티 → Drift ProblemsCompanion (INSERT/UPDATE용)
  static db.ProblemsCompanion toCompanion(domain.Problem problem) {
    return db.ProblemsCompanion(
      id: drift.Value<String>(problem.id),
      originalImagePath: drift.Value<String>(problem.originalImagePath),
      processedImagePath: drift.Value<String?>(problem.processedImagePath),
      ocrText: drift.Value<String?>(problem.ocrText),
      latex: drift.Value<String?>(problem.latex),
      subject: drift.Value<String>(_subjectToString(problem.subject)),
      unit: drift.Value<String?>(problem.unit),
      difficulty: drift.Value<String?>(_difficultyToString(problem.difficulty)),
      wrongCount: drift.Value<int>(problem.wrongCount),
      userNote: drift.Value<String?>(problem.userNote),
      createdAt: drift.Value<int>(problem.createdAt.millisecondsSinceEpoch),
      lastReviewedAt: drift.Value<int?>(problem.lastReviewedAt?.millisecondsSinceEpoch),
      nextReviewAt: drift.Value<int>(problem.nextReviewAt.millisecondsSinceEpoch),
      intervalDays: drift.Value<int>(problem.schedule.intervalDays),
      easeFactor: drift.Value<double>(problem.schedule.easeFactor),
      repetitions: drift.Value<int>(problem.schedule.repetitions),
      contentHash: drift.Value<String?>(problem.contentHash),
      syncStatus: drift.Value<String>(_syncStatusToString(problem.syncStatus)),
    );
  }

  // ===== 열거형 <→ 문자열 변환 =====

  static domain.Subject _parseSubject(String value) {
    switch (value) {
      case 'korean':
        return domain.Subject.korean;
      case 'english':
        return domain.Subject.english;
      case 'math':
        return domain.Subject.math;
      case 'social':
        return domain.Subject.social;
      case 'science':
        return domain.Subject.science;
      default:
        throw ArgumentError('Unknown subject: $value');
    }
  }

  static String _subjectToString(domain.Subject subject) {
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

  static domain.Difficulty? _parseDifficulty(String value) {
    switch (value) {
      case 'hard':
        return domain.Difficulty.hard;
      case 'medium':
        return domain.Difficulty.medium;
      case 'easy':
        return domain.Difficulty.easy;
      default:
        return null;
    }
  }

  static String? _difficultyToString(domain.Difficulty? difficulty) {
    switch (difficulty) {
      case domain.Difficulty.hard:
        return 'hard';
      case domain.Difficulty.medium:
        return 'medium';
      case domain.Difficulty.easy:
        return 'easy';
      case null:
        return null;
    }
  }

  static domain.SyncStatus _parseSyncStatus(String value) {
    switch (value) {
      case 'local':
        return domain.SyncStatus.local;
      case 'pending':
        return domain.SyncStatus.pending;
      case 'synced':
        return domain.SyncStatus.synced;
      case 'conflict':
        return domain.SyncStatus.conflict;
      default:
        throw ArgumentError('Unknown sync status: $value');
    }
  }

  static String _syncStatusToString(domain.SyncStatus status) {
    switch (status) {
      case domain.SyncStatus.local:
        return 'local';
      case domain.SyncStatus.pending:
        return 'pending';
      case domain.SyncStatus.synced:
        return 'synced';
      case domain.SyncStatus.conflict:
        return 'conflict';
    }
  }
}
