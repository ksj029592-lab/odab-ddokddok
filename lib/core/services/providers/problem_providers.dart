import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odab_ddokddok/core/domain/entities/problem.dart' as domain;
import 'package:odab_ddokddok/core/domain/entities/review_schedule.dart';
import 'package:odab_ddokddok/core/domain/repositories/problem_repository.dart';

/// Provides the problem repository (singleton)
/// In production, this would be initialized with a real AppDatabase.
/// Tests override this provider with a test instance.
final problemRepositoryProvider = Provider<ProblemRepository>((ref) {
  throw UnsupportedError(
    'problemRepositoryProvider must be overridden with a concrete implementation',
  );
});

/// Finds a problem by ID (FutureProvider)
final findProblemProvider = FutureProvider.family<domain.Problem?, String>((ref, id) async {
  final repository = ref.watch(problemRepositoryProvider);
  return repository.findById(id);
});

/// Watches problems filtered by subject (StreamProvider.family)
final problemsBySubjectProvider = StreamProvider.family<List<domain.Problem>, domain.Subject>((ref, subject) {
  final repository = ref.watch(problemRepositoryProvider);
  return repository.watchBySubject(subject);
});

/// Watches problems due for review (StreamProvider.family)
final dueProblemsProvider = StreamProvider.family<List<domain.Problem>, DateTime>((ref, now) {
  final repository = ref.watch(problemRepositoryProvider);
  return repository.watchDueForReview(now);
});

/// State notifier for review operations
class ReviewStateNotifier extends StateNotifier<AsyncValue<void>> {
  ReviewStateNotifier(this._repository) : super(const AsyncValue.data(null));

  final ProblemRepository _repository;

  /// Apply a review result to a problem
  Future<void> reviewProblem(String problemId, ReviewResult result) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.applyReviewResult(problemId, result));
  }

  /// Increment the wrong count for a problem
  Future<void> incrementWrongCount(String problemId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.incrementWrongCount(problemId));
  }

  /// Delete a problem
  Future<void> deleteProblem(String problemId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.delete(problemId));
  }
}

/// Provides the review state notifier
final reviewStateNotifierProvider = StateNotifierProvider<ReviewStateNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(problemRepositoryProvider);
  return ReviewStateNotifier(repository);
});


