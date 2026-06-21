import 'package:odab_ddokddok/core/domain/entities/review_schedule.dart';

enum Subject { korean, english, math, social, science }

enum Difficulty { hard, medium, easy }

enum SyncStatus { local, pending, synced, conflict }

class Problem {
  const Problem({
    required this.id,
    required this.originalImagePath,
    this.processedImagePath,
    this.ocrText,
    this.latex,
    required this.subject,
    this.unit,
    required this.tags,
    this.difficulty,
    required this.wrongCount,
    this.userNote,
    required this.createdAt,
    this.lastReviewedAt,
    required this.nextReviewAt,
    required this.schedule,
    this.contentHash,
    this.embedding,
    required this.syncStatus,
  });

  final String id;
  final String originalImagePath;
  final String? processedImagePath;
  final String? ocrText;
  final String? latex;
  final Subject subject;
  final String? unit;
  final List<String> tags;
  final Difficulty? difficulty;
  final int wrongCount;
  final String? userNote;
  final DateTime createdAt;
  final DateTime? lastReviewedAt;
  final DateTime nextReviewAt;
  final ReviewSchedule schedule;
  final String? contentHash;
  final List<double>? embedding;
  final SyncStatus syncStatus;

  Problem copyWith({
    String? id,
    String? originalImagePath,
    String? processedImagePath,
    String? ocrText,
    String? latex,
    Subject? subject,
    String? unit,
    List<String>? tags,
    Difficulty? difficulty,
    int? wrongCount,
    String? userNote,
    DateTime? createdAt,
    DateTime? lastReviewedAt,
    DateTime? nextReviewAt,
    ReviewSchedule? schedule,
    String? contentHash,
    List<double>? embedding,
    SyncStatus? syncStatus,
  }) {
    return Problem(
      id: id ?? this.id,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      processedImagePath: processedImagePath ?? this.processedImagePath,
      ocrText: ocrText ?? this.ocrText,
      latex: latex ?? this.latex,
      subject: subject ?? this.subject,
      unit: unit ?? this.unit,
      tags: tags ?? this.tags,
      difficulty: difficulty ?? this.difficulty,
      wrongCount: wrongCount ?? this.wrongCount,
      userNote: userNote ?? this.userNote,
      createdAt: createdAt ?? this.createdAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      schedule: schedule ?? this.schedule,
      contentHash: contentHash ?? this.contentHash,
      embedding: embedding ?? this.embedding,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
