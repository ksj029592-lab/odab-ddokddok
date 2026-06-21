import 'dart:typed_data';

/// Abstraction for perspective correction engine.
///
/// A real implementation can wrap OpenCV processing.
abstract class PerspectiveCorrectionEngine {
  Future<Uint8List> correct(Uint8List imageBytes);
}

/// Default placeholder engine.
///
/// For now it returns the input as-is. This keeps business logic testable
/// while OpenCV plugin integration is added incrementally.
class PassthroughPerspectiveCorrectionEngine implements PerspectiveCorrectionEngine {
  @override
  Future<Uint8List> correct(Uint8List imageBytes) async {
    return imageBytes;
  }
}

class PerspectiveCorrectionResult {
  const PerspectiveCorrectionResult({
    required this.correctedBytes,
    required this.wasCorrected,
    required this.fallbackUsed,
    required this.processingTimeMs,
    this.errorMessage,
  });

  final Uint8List correctedBytes;
  final bool wasCorrected;
  final bool fallbackUsed;
  final int processingTimeMs;
  final String? errorMessage;
}

/// Service that orchestrates perspective correction + fallback policy.
class PerspectiveCorrectorService {
  PerspectiveCorrectorService({required PerspectiveCorrectionEngine engine})
      : _engine = engine;

  final PerspectiveCorrectionEngine _engine;

  Future<PerspectiveCorrectionResult> correct(Uint8List imageBytes) async {
    if (imageBytes.isEmpty) {
      throw ArgumentError('Image bytes cannot be empty');
    }

    final Stopwatch sw = Stopwatch()..start();

    try {
      final Uint8List corrected = await _engine.correct(imageBytes);
      sw.stop();

      final bool changed = !_equalsBytes(imageBytes, corrected);
      return PerspectiveCorrectionResult(
        correctedBytes: corrected,
        wasCorrected: changed,
        fallbackUsed: false,
        processingTimeMs: sw.elapsedMilliseconds,
      );
    } catch (e) {
      sw.stop();

      return PerspectiveCorrectionResult(
        correctedBytes: imageBytes,
        wasCorrected: false,
        fallbackUsed: true,
        processingTimeMs: sw.elapsedMilliseconds,
        errorMessage: e.toString(),
      );
    }
  }

  static bool _equalsBytes(Uint8List a, Uint8List b) {
    if (identical(a, b)) {
      return true;
    }
    if (a.lengthInBytes != b.lengthInBytes) {
      return false;
    }
    for (int i = 0; i < a.lengthInBytes; i += 1) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }
}
