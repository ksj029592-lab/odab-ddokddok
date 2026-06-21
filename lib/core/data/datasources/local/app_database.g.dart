// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProblemsTable extends Problems with TableInfo<$ProblemsTable, Problem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProblemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originalImagePathMeta =
      const VerificationMeta('originalImagePath');
  @override
  late final GeneratedColumn<String> originalImagePath =
      GeneratedColumn<String>('original_image_path', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _processedImagePathMeta =
      const VerificationMeta('processedImagePath');
  @override
  late final GeneratedColumn<String> processedImagePath =
      GeneratedColumn<String>('processed_image_path', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ocrTextMeta =
      const VerificationMeta('ocrText');
  @override
  late final GeneratedColumn<String> ocrText = GeneratedColumn<String>(
      'ocr_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latexMeta = const VerificationMeta('latex');
  @override
  late final GeneratedColumn<String> latex = GeneratedColumn<String>(
      'latex', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _subjectMeta =
      const VerificationMeta('subject');
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
      'subject', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _wrongCountMeta =
      const VerificationMeta('wrongCount');
  @override
  late final GeneratedColumn<int> wrongCount = GeneratedColumn<int>(
      'wrong_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _userNoteMeta =
      const VerificationMeta('userNote');
  @override
  late final GeneratedColumn<String> userNote = GeneratedColumn<String>(
      'user_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastReviewedAtMeta =
      const VerificationMeta('lastReviewedAt');
  @override
  late final GeneratedColumn<int> lastReviewedAt = GeneratedColumn<int>(
      'last_reviewed_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nextReviewAtMeta =
      const VerificationMeta('nextReviewAt');
  @override
  late final GeneratedColumn<int> nextReviewAt = GeneratedColumn<int>(
      'next_review_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
      'interval_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _easeFactorMeta =
      const VerificationMeta('easeFactor');
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
      'ease_factor', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _repetitionsMeta =
      const VerificationMeta('repetitions');
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
      'repetitions', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _contentHashMeta =
      const VerificationMeta('contentHash');
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
      'content_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('local'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        originalImagePath,
        processedImagePath,
        ocrText,
        latex,
        subject,
        unit,
        difficulty,
        wrongCount,
        userNote,
        createdAt,
        lastReviewedAt,
        nextReviewAt,
        intervalDays,
        easeFactor,
        repetitions,
        contentHash,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'problems';
  @override
  VerificationContext validateIntegrity(Insertable<Problem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('original_image_path')) {
      context.handle(
          _originalImagePathMeta,
          originalImagePath.isAcceptableOrUnknown(
              data['original_image_path']!, _originalImagePathMeta));
    } else if (isInserting) {
      context.missing(_originalImagePathMeta);
    }
    if (data.containsKey('processed_image_path')) {
      context.handle(
          _processedImagePathMeta,
          processedImagePath.isAcceptableOrUnknown(
              data['processed_image_path']!, _processedImagePathMeta));
    }
    if (data.containsKey('ocr_text')) {
      context.handle(_ocrTextMeta,
          ocrText.isAcceptableOrUnknown(data['ocr_text']!, _ocrTextMeta));
    }
    if (data.containsKey('latex')) {
      context.handle(
          _latexMeta, latex.isAcceptableOrUnknown(data['latex']!, _latexMeta));
    }
    if (data.containsKey('subject')) {
      context.handle(_subjectMeta,
          subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta));
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    }
    if (data.containsKey('wrong_count')) {
      context.handle(
          _wrongCountMeta,
          wrongCount.isAcceptableOrUnknown(
              data['wrong_count']!, _wrongCountMeta));
    }
    if (data.containsKey('user_note')) {
      context.handle(_userNoteMeta,
          userNote.isAcceptableOrUnknown(data['user_note']!, _userNoteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
          _lastReviewedAtMeta,
          lastReviewedAt.isAcceptableOrUnknown(
              data['last_reviewed_at']!, _lastReviewedAtMeta));
    }
    if (data.containsKey('next_review_at')) {
      context.handle(
          _nextReviewAtMeta,
          nextReviewAt.isAcceptableOrUnknown(
              data['next_review_at']!, _nextReviewAtMeta));
    } else if (isInserting) {
      context.missing(_nextReviewAtMeta);
    }
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    } else if (isInserting) {
      context.missing(_intervalDaysMeta);
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
          _easeFactorMeta,
          easeFactor.isAcceptableOrUnknown(
              data['ease_factor']!, _easeFactorMeta));
    } else if (isInserting) {
      context.missing(_easeFactorMeta);
    }
    if (data.containsKey('repetitions')) {
      context.handle(
          _repetitionsMeta,
          repetitions.isAcceptableOrUnknown(
              data['repetitions']!, _repetitionsMeta));
    } else if (isInserting) {
      context.missing(_repetitionsMeta);
    }
    if (data.containsKey('content_hash')) {
      context.handle(
          _contentHashMeta,
          contentHash.isAcceptableOrUnknown(
              data['content_hash']!, _contentHashMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Problem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Problem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      originalImagePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}original_image_path'])!,
      processedImagePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}processed_image_path']),
      ocrText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ocr_text']),
      latex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}latex']),
      subject: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty']),
      wrongCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wrong_count'])!,
      userNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      lastReviewedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_reviewed_at']),
      nextReviewAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}next_review_at'])!,
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_days'])!,
      easeFactor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ease_factor'])!,
      repetitions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}repetitions'])!,
      contentHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_hash']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $ProblemsTable createAlias(String alias) {
    return $ProblemsTable(attachedDatabase, alias);
  }
}

class Problem extends DataClass implements Insertable<Problem> {
  final String id;
  final String originalImagePath;
  final String? processedImagePath;
  final String? ocrText;
  final String? latex;
  final String subject;
  final String? unit;
  final String? difficulty;
  final int wrongCount;
  final String? userNote;
  final int createdAt;
  final int? lastReviewedAt;
  final int nextReviewAt;
  final int intervalDays;
  final double easeFactor;
  final int repetitions;
  final String? contentHash;
  final String syncStatus;
  const Problem(
      {required this.id,
      required this.originalImagePath,
      this.processedImagePath,
      this.ocrText,
      this.latex,
      required this.subject,
      this.unit,
      this.difficulty,
      required this.wrongCount,
      this.userNote,
      required this.createdAt,
      this.lastReviewedAt,
      required this.nextReviewAt,
      required this.intervalDays,
      required this.easeFactor,
      required this.repetitions,
      this.contentHash,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['original_image_path'] = Variable<String>(originalImagePath);
    if (!nullToAbsent || processedImagePath != null) {
      map['processed_image_path'] = Variable<String>(processedImagePath);
    }
    if (!nullToAbsent || ocrText != null) {
      map['ocr_text'] = Variable<String>(ocrText);
    }
    if (!nullToAbsent || latex != null) {
      map['latex'] = Variable<String>(latex);
    }
    map['subject'] = Variable<String>(subject);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<String>(difficulty);
    }
    map['wrong_count'] = Variable<int>(wrongCount);
    if (!nullToAbsent || userNote != null) {
      map['user_note'] = Variable<String>(userNote);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<int>(lastReviewedAt);
    }
    map['next_review_at'] = Variable<int>(nextReviewAt);
    map['interval_days'] = Variable<int>(intervalDays);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['repetitions'] = Variable<int>(repetitions);
    if (!nullToAbsent || contentHash != null) {
      map['content_hash'] = Variable<String>(contentHash);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  ProblemsCompanion toCompanion(bool nullToAbsent) {
    return ProblemsCompanion(
      id: Value(id),
      originalImagePath: Value(originalImagePath),
      processedImagePath: processedImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(processedImagePath),
      ocrText: ocrText == null && nullToAbsent
          ? const Value.absent()
          : Value(ocrText),
      latex:
          latex == null && nullToAbsent ? const Value.absent() : Value(latex),
      subject: Value(subject),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      wrongCount: Value(wrongCount),
      userNote: userNote == null && nullToAbsent
          ? const Value.absent()
          : Value(userNote),
      createdAt: Value(createdAt),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
      nextReviewAt: Value(nextReviewAt),
      intervalDays: Value(intervalDays),
      easeFactor: Value(easeFactor),
      repetitions: Value(repetitions),
      contentHash: contentHash == null && nullToAbsent
          ? const Value.absent()
          : Value(contentHash),
      syncStatus: Value(syncStatus),
    );
  }

  factory Problem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Problem(
      id: serializer.fromJson<String>(json['id']),
      originalImagePath: serializer.fromJson<String>(json['originalImagePath']),
      processedImagePath:
          serializer.fromJson<String?>(json['processedImagePath']),
      ocrText: serializer.fromJson<String?>(json['ocrText']),
      latex: serializer.fromJson<String?>(json['latex']),
      subject: serializer.fromJson<String>(json['subject']),
      unit: serializer.fromJson<String?>(json['unit']),
      difficulty: serializer.fromJson<String?>(json['difficulty']),
      wrongCount: serializer.fromJson<int>(json['wrongCount']),
      userNote: serializer.fromJson<String?>(json['userNote']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      lastReviewedAt: serializer.fromJson<int?>(json['lastReviewedAt']),
      nextReviewAt: serializer.fromJson<int>(json['nextReviewAt']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      contentHash: serializer.fromJson<String?>(json['contentHash']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'originalImagePath': serializer.toJson<String>(originalImagePath),
      'processedImagePath': serializer.toJson<String?>(processedImagePath),
      'ocrText': serializer.toJson<String?>(ocrText),
      'latex': serializer.toJson<String?>(latex),
      'subject': serializer.toJson<String>(subject),
      'unit': serializer.toJson<String?>(unit),
      'difficulty': serializer.toJson<String?>(difficulty),
      'wrongCount': serializer.toJson<int>(wrongCount),
      'userNote': serializer.toJson<String?>(userNote),
      'createdAt': serializer.toJson<int>(createdAt),
      'lastReviewedAt': serializer.toJson<int?>(lastReviewedAt),
      'nextReviewAt': serializer.toJson<int>(nextReviewAt),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'repetitions': serializer.toJson<int>(repetitions),
      'contentHash': serializer.toJson<String?>(contentHash),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Problem copyWith(
          {String? id,
          String? originalImagePath,
          Value<String?> processedImagePath = const Value.absent(),
          Value<String?> ocrText = const Value.absent(),
          Value<String?> latex = const Value.absent(),
          String? subject,
          Value<String?> unit = const Value.absent(),
          Value<String?> difficulty = const Value.absent(),
          int? wrongCount,
          Value<String?> userNote = const Value.absent(),
          int? createdAt,
          Value<int?> lastReviewedAt = const Value.absent(),
          int? nextReviewAt,
          int? intervalDays,
          double? easeFactor,
          int? repetitions,
          Value<String?> contentHash = const Value.absent(),
          String? syncStatus}) =>
      Problem(
        id: id ?? this.id,
        originalImagePath: originalImagePath ?? this.originalImagePath,
        processedImagePath: processedImagePath.present
            ? processedImagePath.value
            : this.processedImagePath,
        ocrText: ocrText.present ? ocrText.value : this.ocrText,
        latex: latex.present ? latex.value : this.latex,
        subject: subject ?? this.subject,
        unit: unit.present ? unit.value : this.unit,
        difficulty: difficulty.present ? difficulty.value : this.difficulty,
        wrongCount: wrongCount ?? this.wrongCount,
        userNote: userNote.present ? userNote.value : this.userNote,
        createdAt: createdAt ?? this.createdAt,
        lastReviewedAt:
            lastReviewedAt.present ? lastReviewedAt.value : this.lastReviewedAt,
        nextReviewAt: nextReviewAt ?? this.nextReviewAt,
        intervalDays: intervalDays ?? this.intervalDays,
        easeFactor: easeFactor ?? this.easeFactor,
        repetitions: repetitions ?? this.repetitions,
        contentHash: contentHash.present ? contentHash.value : this.contentHash,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  Problem copyWithCompanion(ProblemsCompanion data) {
    return Problem(
      id: data.id.present ? data.id.value : this.id,
      originalImagePath: data.originalImagePath.present
          ? data.originalImagePath.value
          : this.originalImagePath,
      processedImagePath: data.processedImagePath.present
          ? data.processedImagePath.value
          : this.processedImagePath,
      ocrText: data.ocrText.present ? data.ocrText.value : this.ocrText,
      latex: data.latex.present ? data.latex.value : this.latex,
      subject: data.subject.present ? data.subject.value : this.subject,
      unit: data.unit.present ? data.unit.value : this.unit,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      wrongCount:
          data.wrongCount.present ? data.wrongCount.value : this.wrongCount,
      userNote: data.userNote.present ? data.userNote.value : this.userNote,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
      nextReviewAt: data.nextReviewAt.present
          ? data.nextReviewAt.value
          : this.nextReviewAt,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      easeFactor:
          data.easeFactor.present ? data.easeFactor.value : this.easeFactor,
      repetitions:
          data.repetitions.present ? data.repetitions.value : this.repetitions,
      contentHash:
          data.contentHash.present ? data.contentHash.value : this.contentHash,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Problem(')
          ..write('id: $id, ')
          ..write('originalImagePath: $originalImagePath, ')
          ..write('processedImagePath: $processedImagePath, ')
          ..write('ocrText: $ocrText, ')
          ..write('latex: $latex, ')
          ..write('subject: $subject, ')
          ..write('unit: $unit, ')
          ..write('difficulty: $difficulty, ')
          ..write('wrongCount: $wrongCount, ')
          ..write('userNote: $userNote, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('repetitions: $repetitions, ')
          ..write('contentHash: $contentHash, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      originalImagePath,
      processedImagePath,
      ocrText,
      latex,
      subject,
      unit,
      difficulty,
      wrongCount,
      userNote,
      createdAt,
      lastReviewedAt,
      nextReviewAt,
      intervalDays,
      easeFactor,
      repetitions,
      contentHash,
      syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Problem &&
          other.id == this.id &&
          other.originalImagePath == this.originalImagePath &&
          other.processedImagePath == this.processedImagePath &&
          other.ocrText == this.ocrText &&
          other.latex == this.latex &&
          other.subject == this.subject &&
          other.unit == this.unit &&
          other.difficulty == this.difficulty &&
          other.wrongCount == this.wrongCount &&
          other.userNote == this.userNote &&
          other.createdAt == this.createdAt &&
          other.lastReviewedAt == this.lastReviewedAt &&
          other.nextReviewAt == this.nextReviewAt &&
          other.intervalDays == this.intervalDays &&
          other.easeFactor == this.easeFactor &&
          other.repetitions == this.repetitions &&
          other.contentHash == this.contentHash &&
          other.syncStatus == this.syncStatus);
}

class ProblemsCompanion extends UpdateCompanion<Problem> {
  final Value<String> id;
  final Value<String> originalImagePath;
  final Value<String?> processedImagePath;
  final Value<String?> ocrText;
  final Value<String?> latex;
  final Value<String> subject;
  final Value<String?> unit;
  final Value<String?> difficulty;
  final Value<int> wrongCount;
  final Value<String?> userNote;
  final Value<int> createdAt;
  final Value<int?> lastReviewedAt;
  final Value<int> nextReviewAt;
  final Value<int> intervalDays;
  final Value<double> easeFactor;
  final Value<int> repetitions;
  final Value<String?> contentHash;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const ProblemsCompanion({
    this.id = const Value.absent(),
    this.originalImagePath = const Value.absent(),
    this.processedImagePath = const Value.absent(),
    this.ocrText = const Value.absent(),
    this.latex = const Value.absent(),
    this.subject = const Value.absent(),
    this.unit = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.wrongCount = const Value.absent(),
    this.userNote = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProblemsCompanion.insert({
    required String id,
    required String originalImagePath,
    this.processedImagePath = const Value.absent(),
    this.ocrText = const Value.absent(),
    this.latex = const Value.absent(),
    required String subject,
    this.unit = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.wrongCount = const Value.absent(),
    this.userNote = const Value.absent(),
    required int createdAt,
    this.lastReviewedAt = const Value.absent(),
    required int nextReviewAt,
    required int intervalDays,
    required double easeFactor,
    required int repetitions,
    this.contentHash = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        originalImagePath = Value(originalImagePath),
        subject = Value(subject),
        createdAt = Value(createdAt),
        nextReviewAt = Value(nextReviewAt),
        intervalDays = Value(intervalDays),
        easeFactor = Value(easeFactor),
        repetitions = Value(repetitions);
  static Insertable<Problem> custom({
    Expression<String>? id,
    Expression<String>? originalImagePath,
    Expression<String>? processedImagePath,
    Expression<String>? ocrText,
    Expression<String>? latex,
    Expression<String>? subject,
    Expression<String>? unit,
    Expression<String>? difficulty,
    Expression<int>? wrongCount,
    Expression<String>? userNote,
    Expression<int>? createdAt,
    Expression<int>? lastReviewedAt,
    Expression<int>? nextReviewAt,
    Expression<int>? intervalDays,
    Expression<double>? easeFactor,
    Expression<int>? repetitions,
    Expression<String>? contentHash,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (originalImagePath != null) 'original_image_path': originalImagePath,
      if (processedImagePath != null)
        'processed_image_path': processedImagePath,
      if (ocrText != null) 'ocr_text': ocrText,
      if (latex != null) 'latex': latex,
      if (subject != null) 'subject': subject,
      if (unit != null) 'unit': unit,
      if (difficulty != null) 'difficulty': difficulty,
      if (wrongCount != null) 'wrong_count': wrongCount,
      if (userNote != null) 'user_note': userNote,
      if (createdAt != null) 'created_at': createdAt,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (nextReviewAt != null) 'next_review_at': nextReviewAt,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (repetitions != null) 'repetitions': repetitions,
      if (contentHash != null) 'content_hash': contentHash,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProblemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? originalImagePath,
      Value<String?>? processedImagePath,
      Value<String?>? ocrText,
      Value<String?>? latex,
      Value<String>? subject,
      Value<String?>? unit,
      Value<String?>? difficulty,
      Value<int>? wrongCount,
      Value<String?>? userNote,
      Value<int>? createdAt,
      Value<int?>? lastReviewedAt,
      Value<int>? nextReviewAt,
      Value<int>? intervalDays,
      Value<double>? easeFactor,
      Value<int>? repetitions,
      Value<String?>? contentHash,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return ProblemsCompanion(
      id: id ?? this.id,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      processedImagePath: processedImagePath ?? this.processedImagePath,
      ocrText: ocrText ?? this.ocrText,
      latex: latex ?? this.latex,
      subject: subject ?? this.subject,
      unit: unit ?? this.unit,
      difficulty: difficulty ?? this.difficulty,
      wrongCount: wrongCount ?? this.wrongCount,
      userNote: userNote ?? this.userNote,
      createdAt: createdAt ?? this.createdAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      repetitions: repetitions ?? this.repetitions,
      contentHash: contentHash ?? this.contentHash,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (originalImagePath.present) {
      map['original_image_path'] = Variable<String>(originalImagePath.value);
    }
    if (processedImagePath.present) {
      map['processed_image_path'] = Variable<String>(processedImagePath.value);
    }
    if (ocrText.present) {
      map['ocr_text'] = Variable<String>(ocrText.value);
    }
    if (latex.present) {
      map['latex'] = Variable<String>(latex.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (wrongCount.present) {
      map['wrong_count'] = Variable<int>(wrongCount.value);
    }
    if (userNote.present) {
      map['user_note'] = Variable<String>(userNote.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<int>(lastReviewedAt.value);
    }
    if (nextReviewAt.present) {
      map['next_review_at'] = Variable<int>(nextReviewAt.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProblemsCompanion(')
          ..write('id: $id, ')
          ..write('originalImagePath: $originalImagePath, ')
          ..write('processedImagePath: $processedImagePath, ')
          ..write('ocrText: $ocrText, ')
          ..write('latex: $latex, ')
          ..write('subject: $subject, ')
          ..write('unit: $unit, ')
          ..write('difficulty: $difficulty, ')
          ..write('wrongCount: $wrongCount, ')
          ..write('userNote: $userNote, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('repetitions: $repetitions, ')
          ..write('contentHash: $contentHash, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _problemIdMeta =
      const VerificationMeta('problemId');
  @override
  late final GeneratedColumn<String> problemId = GeneratedColumn<String>(
      'problem_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES problems (id) ON DELETE CASCADE'));
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
      'tag', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [problemId, tag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(Insertable<Tag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('problem_id')) {
      context.handle(_problemIdMeta,
          problemId.isAcceptableOrUnknown(data['problem_id']!, _problemIdMeta));
    } else if (isInserting) {
      context.missing(_problemIdMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
          _tagMeta, tag.isAcceptableOrUnknown(data['tag']!, _tagMeta));
    } else if (isInserting) {
      context.missing(_tagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {problemId, tag};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      problemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}problem_id'])!,
      tag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag'])!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String problemId;
  final String tag;
  const Tag({required this.problemId, required this.tag});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['problem_id'] = Variable<String>(problemId);
    map['tag'] = Variable<String>(tag);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      problemId: Value(problemId),
      tag: Value(tag),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      problemId: serializer.fromJson<String>(json['problemId']),
      tag: serializer.fromJson<String>(json['tag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'problemId': serializer.toJson<String>(problemId),
      'tag': serializer.toJson<String>(tag),
    };
  }

  Tag copyWith({String? problemId, String? tag}) => Tag(
        problemId: problemId ?? this.problemId,
        tag: tag ?? this.tag,
      );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      problemId: data.problemId.present ? data.problemId.value : this.problemId,
      tag: data.tag.present ? data.tag.value : this.tag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('problemId: $problemId, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(problemId, tag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.problemId == this.problemId &&
          other.tag == this.tag);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> problemId;
  final Value<String> tag;
  final Value<int> rowid;
  const TagsCompanion({
    this.problemId = const Value.absent(),
    this.tag = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String problemId,
    required String tag,
    this.rowid = const Value.absent(),
  })  : problemId = Value(problemId),
        tag = Value(tag);
  static Insertable<Tag> custom({
    Expression<String>? problemId,
    Expression<String>? tag,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (problemId != null) 'problem_id': problemId,
      if (tag != null) 'tag': tag,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith(
      {Value<String>? problemId, Value<String>? tag, Value<int>? rowid}) {
    return TagsCompanion(
      problemId: problemId ?? this.problemId,
      tag: tag ?? this.tag,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (problemId.present) {
      map['problem_id'] = Variable<String>(problemId.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('problemId: $problemId, ')
          ..write('tag: $tag, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProblemsTable problems = $ProblemsTable(this);
  late final $TagsTable tags = $TagsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [problems, tags];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('problems',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('tags', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ProblemsTableCreateCompanionBuilder = ProblemsCompanion Function({
  required String id,
  required String originalImagePath,
  Value<String?> processedImagePath,
  Value<String?> ocrText,
  Value<String?> latex,
  required String subject,
  Value<String?> unit,
  Value<String?> difficulty,
  Value<int> wrongCount,
  Value<String?> userNote,
  required int createdAt,
  Value<int?> lastReviewedAt,
  required int nextReviewAt,
  required int intervalDays,
  required double easeFactor,
  required int repetitions,
  Value<String?> contentHash,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$ProblemsTableUpdateCompanionBuilder = ProblemsCompanion Function({
  Value<String> id,
  Value<String> originalImagePath,
  Value<String?> processedImagePath,
  Value<String?> ocrText,
  Value<String?> latex,
  Value<String> subject,
  Value<String?> unit,
  Value<String?> difficulty,
  Value<int> wrongCount,
  Value<String?> userNote,
  Value<int> createdAt,
  Value<int?> lastReviewedAt,
  Value<int> nextReviewAt,
  Value<int> intervalDays,
  Value<double> easeFactor,
  Value<int> repetitions,
  Value<String?> contentHash,
  Value<String> syncStatus,
  Value<int> rowid,
});

final class $$ProblemsTableReferences
    extends BaseReferences<_$AppDatabase, $ProblemsTable, Problem> {
  $$ProblemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TagsTable, List<Tag>> _tagsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.tags,
          aliasName: 'problems__id__tags__problem_id');

  $$TagsTableProcessedTableManager get tagsRefs {
    final manager = $$TagsTableTableManager($_db, $_db.tags)
        .filter((f) => f.problemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProblemsTableFilterComposer
    extends Composer<_$AppDatabase, $ProblemsTable> {
  $$ProblemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalImagePath => $composableBuilder(
      column: $table.originalImagePath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get processedImagePath => $composableBuilder(
      column: $table.processedImagePath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ocrText => $composableBuilder(
      column: $table.ocrText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get latex => $composableBuilder(
      column: $table.latex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subject => $composableBuilder(
      column: $table.subject, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wrongCount => $composableBuilder(
      column: $table.wrongCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userNote => $composableBuilder(
      column: $table.userNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  Expression<bool> tagsRefs(
      Expression<bool> Function($$TagsTableFilterComposer f) f) {
    final $$TagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.problemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableFilterComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProblemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProblemsTable> {
  $$ProblemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalImagePath => $composableBuilder(
      column: $table.originalImagePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get processedImagePath => $composableBuilder(
      column: $table.processedImagePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ocrText => $composableBuilder(
      column: $table.ocrText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get latex => $composableBuilder(
      column: $table.latex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subject => $composableBuilder(
      column: $table.subject, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wrongCount => $composableBuilder(
      column: $table.wrongCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userNote => $composableBuilder(
      column: $table.userNote, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$ProblemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProblemsTable> {
  $$ProblemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get originalImagePath => $composableBuilder(
      column: $table.originalImagePath, builder: (column) => column);

  GeneratedColumn<String> get processedImagePath => $composableBuilder(
      column: $table.processedImagePath, builder: (column) => column);

  GeneratedColumn<String> get ocrText =>
      $composableBuilder(column: $table.ocrText, builder: (column) => column);

  GeneratedColumn<String> get latex =>
      $composableBuilder(column: $table.latex, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<int> get wrongCount => $composableBuilder(
      column: $table.wrongCount, builder: (column) => column);

  GeneratedColumn<String> get userNote =>
      $composableBuilder(column: $table.userNote, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt, builder: (column) => column);

  GeneratedColumn<int> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  Expression<T> tagsRefs<T extends Object>(
      Expression<T> Function($$TagsTableAnnotationComposer a) f) {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.problemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableAnnotationComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProblemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProblemsTable,
    Problem,
    $$ProblemsTableFilterComposer,
    $$ProblemsTableOrderingComposer,
    $$ProblemsTableAnnotationComposer,
    $$ProblemsTableCreateCompanionBuilder,
    $$ProblemsTableUpdateCompanionBuilder,
    (Problem, $$ProblemsTableReferences),
    Problem,
    PrefetchHooks Function({bool tagsRefs})> {
  $$ProblemsTableTableManager(_$AppDatabase db, $ProblemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProblemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProblemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProblemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> originalImagePath = const Value.absent(),
            Value<String?> processedImagePath = const Value.absent(),
            Value<String?> ocrText = const Value.absent(),
            Value<String?> latex = const Value.absent(),
            Value<String> subject = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> difficulty = const Value.absent(),
            Value<int> wrongCount = const Value.absent(),
            Value<String?> userNote = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int?> lastReviewedAt = const Value.absent(),
            Value<int> nextReviewAt = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<int> repetitions = const Value.absent(),
            Value<String?> contentHash = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProblemsCompanion(
            id: id,
            originalImagePath: originalImagePath,
            processedImagePath: processedImagePath,
            ocrText: ocrText,
            latex: latex,
            subject: subject,
            unit: unit,
            difficulty: difficulty,
            wrongCount: wrongCount,
            userNote: userNote,
            createdAt: createdAt,
            lastReviewedAt: lastReviewedAt,
            nextReviewAt: nextReviewAt,
            intervalDays: intervalDays,
            easeFactor: easeFactor,
            repetitions: repetitions,
            contentHash: contentHash,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String originalImagePath,
            Value<String?> processedImagePath = const Value.absent(),
            Value<String?> ocrText = const Value.absent(),
            Value<String?> latex = const Value.absent(),
            required String subject,
            Value<String?> unit = const Value.absent(),
            Value<String?> difficulty = const Value.absent(),
            Value<int> wrongCount = const Value.absent(),
            Value<String?> userNote = const Value.absent(),
            required int createdAt,
            Value<int?> lastReviewedAt = const Value.absent(),
            required int nextReviewAt,
            required int intervalDays,
            required double easeFactor,
            required int repetitions,
            Value<String?> contentHash = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProblemsCompanion.insert(
            id: id,
            originalImagePath: originalImagePath,
            processedImagePath: processedImagePath,
            ocrText: ocrText,
            latex: latex,
            subject: subject,
            unit: unit,
            difficulty: difficulty,
            wrongCount: wrongCount,
            userNote: userNote,
            createdAt: createdAt,
            lastReviewedAt: lastReviewedAt,
            nextReviewAt: nextReviewAt,
            intervalDays: intervalDays,
            easeFactor: easeFactor,
            repetitions: repetitions,
            contentHash: contentHash,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProblemsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({tagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tagsRefs) db.tags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tagsRefs)
                    await $_getPrefetchedData<Problem, $ProblemsTable, Tag>(
                        currentTable: table,
                        referencedTable:
                            $$ProblemsTableReferences._tagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProblemsTableReferences(db, table, p0).tagsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.problemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProblemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProblemsTable,
    Problem,
    $$ProblemsTableFilterComposer,
    $$ProblemsTableOrderingComposer,
    $$ProblemsTableAnnotationComposer,
    $$ProblemsTableCreateCompanionBuilder,
    $$ProblemsTableUpdateCompanionBuilder,
    (Problem, $$ProblemsTableReferences),
    Problem,
    PrefetchHooks Function({bool tagsRefs})>;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  required String problemId,
  required String tag,
  Value<int> rowid,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<String> problemId,
  Value<String> tag,
  Value<int> rowid,
});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProblemsTable _problemIdTable(_$AppDatabase db) =>
      db.problems.createAlias('tags__problem_id__problems__id');

  $$ProblemsTableProcessedTableManager get problemId {
    final $_column = $_itemColumn<String>('problem_id')!;

    final manager = $$ProblemsTableTableManager($_db, $_db.problems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_problemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tag => $composableBuilder(
      column: $table.tag, builder: (column) => ColumnFilters(column));

  $$ProblemsTableFilterComposer get problemId {
    final $$ProblemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.problemId,
        referencedTable: $db.problems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProblemsTableFilterComposer(
              $db: $db,
              $table: $db.problems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tag => $composableBuilder(
      column: $table.tag, builder: (column) => ColumnOrderings(column));

  $$ProblemsTableOrderingComposer get problemId {
    final $$ProblemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.problemId,
        referencedTable: $db.problems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProblemsTableOrderingComposer(
              $db: $db,
              $table: $db.problems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);

  $$ProblemsTableAnnotationComposer get problemId {
    final $$ProblemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.problemId,
        referencedTable: $db.problems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProblemsTableAnnotationComposer(
              $db: $db,
              $table: $db.problems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, $$TagsTableReferences),
    Tag,
    PrefetchHooks Function({bool problemId})> {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> problemId = const Value.absent(),
            Value<String> tag = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TagsCompanion(
            problemId: problemId,
            tag: tag,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String problemId,
            required String tag,
            Value<int> rowid = const Value.absent(),
          }) =>
              TagsCompanion.insert(
            problemId: problemId,
            tag: tag,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TagsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({problemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (problemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.problemId,
                    referencedTable: $$TagsTableReferences._problemIdTable(db),
                    referencedColumn:
                        $$TagsTableReferences._problemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, $$TagsTableReferences),
    Tag,
    PrefetchHooks Function({bool problemId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProblemsTableTableManager get problems =>
      $$ProblemsTableTableManager(_db, _db.problems);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
}
