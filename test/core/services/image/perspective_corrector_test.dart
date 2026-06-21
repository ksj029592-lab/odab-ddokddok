import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:odab_ddokddok/core/services/image/perspective_corrector.dart';

class _FakeSuccessEngine implements PerspectiveCorrectionEngine {
  _FakeSuccessEngine(this.outputBytes);

  final Uint8List outputBytes;
  int calls = 0;

  @override
  Future<Uint8List> correct(Uint8List imageBytes) async {
    calls += 1;
    return outputBytes;
  }
}

class _FakeFailureEngine implements PerspectiveCorrectionEngine {
  int calls = 0;

  @override
  Future<Uint8List> correct(Uint8List imageBytes) async {
    calls += 1;
    throw StateError('opencv failed');
  }
}

void main() {
  group('PerspectiveCorrectorService', () {
    test('보정 성공 시 보정 결과를 반환한다', () async {
      final input = Uint8List.fromList(<int>[1, 2, 3, 4]);
      final corrected = Uint8List.fromList(<int>[9, 9, 9, 9]);
      final engine = _FakeSuccessEngine(corrected);
      final service = PerspectiveCorrectorService(engine: engine);

      final result = await service.correct(input);

      expect(engine.calls, 1);
      expect(result.correctedBytes, corrected);
      expect(result.wasCorrected, isTrue);
      expect(result.fallbackUsed, isFalse);
      expect(result.processingTimeMs, greaterThanOrEqualTo(0));
    });

    test('보정 실패 시 원본을 fallback으로 반환한다', () async {
      final input = Uint8List.fromList(<int>[5, 6, 7]);
      final engine = _FakeFailureEngine();
      final service = PerspectiveCorrectorService(engine: engine);

      final result = await service.correct(input);

      expect(engine.calls, 1);
      expect(result.correctedBytes, input);
      expect(result.wasCorrected, isFalse);
      expect(result.fallbackUsed, isTrue);
      expect(result.errorMessage, isNotNull);
    });

    test('빈 이미지 입력이면 ArgumentError를 던진다', () async {
      final engine = _FakeSuccessEngine(Uint8List.fromList(<int>[1]));
      final service = PerspectiveCorrectorService(engine: engine);

      expect(
        () => service.correct(Uint8List.fromList(<int>[])),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('50회 평균 처리시간이 500ms 미만이다', () async {
      final input = Uint8List.fromList(List<int>.generate(2048, (i) => i % 256));
      final corrected = Uint8List.fromList(List<int>.generate(2048, (i) => (i + 1) % 256));
      final engine = _FakeSuccessEngine(corrected);
      final service = PerspectiveCorrectorService(engine: engine);

      int totalMs = 0;
      for (int i = 0; i < 50; i += 1) {
        final result = await service.correct(input);
        totalMs += result.processingTimeMs;
      }

      final averageMs = totalMs / 50;
      expect(averageMs, lessThan(500));
      expect(engine.calls, 50);
    });
  });
}
