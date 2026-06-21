import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odab_ddokddok/features/scan/presentation/widgets/manual_crop_editor.dart';

void main() {
  group('ManualCropEditor', () {
    testWidgets('4개 핸들과 회전 버튼을 렌더링한다', (WidgetTester tester) async {
      CropPoints points = CropPoints.initial();
      int turns = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ManualCropEditor(
              points: points,
              onPointsChanged: (CropPoints next) {
                points = next;
              },
              quarterTurns: turns,
              onRotate: () {
                turns = (turns + 1) % 4;
              },
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('crop-handle-top-left')), findsOneWidget);
      expect(find.byKey(const Key('crop-handle-top-right')), findsOneWidget);
      expect(find.byKey(const Key('crop-handle-bottom-right')), findsOneWidget);
      expect(find.byKey(const Key('crop-handle-bottom-left')), findsOneWidget);
      expect(find.byKey(const Key('crop-rotate-button')), findsOneWidget);
    });

    testWidgets('핸들 드래그 시 points 변경 콜백이 호출된다', (WidgetTester tester) async {
      CropPoints changed = CropPoints.initial();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ManualCropEditor(
              points: CropPoints.initial(),
              onPointsChanged: (CropPoints next) {
                changed = next;
              },
              quarterTurns: 0,
              onRotate: () {},
            ),
          ),
        ),
      );

      await tester.drag(find.byKey(const Key('crop-handle-top-left')), const Offset(20, 20));
      await tester.pump(const Duration(milliseconds: 100));

      expect(changed.topLeft.dx, greaterThan(0.1));
      expect(changed.topLeft.dy, greaterThan(0.1));
    });

    testWidgets('회전 버튼 탭 시 콜백이 호출된다', (WidgetTester tester) async {
      int calls = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ManualCropEditor(
              points: CropPoints.initial(),
              onPointsChanged: (_) {},
              quarterTurns: 0,
              onRotate: () {
                calls += 1;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('crop-rotate-button')));
      await tester.pump();

      expect(calls, 1);
    });
  });
}
