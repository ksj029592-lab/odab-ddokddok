import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odab_ddokddok/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  group('OnboardingScreen', () {
    testWidgets('첫 단계에서 권한 안내를 표시한다', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(),
        ),
      );

      expect(find.text('환영합니다'), findsOneWidget);
      expect(find.text('카메라, 저장소, 알림 권한이 필요해요'), findsOneWidget);
      expect(find.text('다음'), findsOneWidget);
      expect(find.text('1/4'), findsOneWidget);
    });

    testWidgets('다음 버튼으로 학년 선택 단계로 이동한다', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(),
        ),
      );

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(find.text('학년을 선택해주세요'), findsOneWidget);
      expect(find.text('중1'), findsOneWidget);
      expect(find.text('고3'), findsOneWidget);
      expect(find.text('건너뛰기'), findsOneWidget);
      expect(find.text('2/4'), findsOneWidget);
    });

    testWidgets('과목 선택 단계는 1개 이상 선택해야 다음으로 진행 가능하다', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(),
        ),
      );

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(find.text('주 과목을 선택해주세요'), findsOneWidget);
      expect(find.text('국어'), findsOneWidget);
      expect(find.text('과학'), findsOneWidget);
      expect(find.text('3/4'), findsOneWidget);

      final nextButton = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, '다음'));
      expect(nextButton.onPressed, isNull);

      await tester.tap(find.text('수학'));
      await tester.pumpAndSettle();

      final enabledNextButton = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, '다음'));
      expect(enabledNextButton.onPressed, isNotNull);
    });

    testWidgets('알림 시간 단계 기본값 08:00, 17:00을 표시한다', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(),
        ),
      );

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('수학'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, '다음'));
      await tester.pumpAndSettle();

      expect(find.text('복습 알림 시간을 설정해주세요'), findsOneWidget);
      expect(find.text('08:00'), findsOneWidget);
      expect(find.text('17:00'), findsOneWidget);
      expect(find.text('완료'), findsOneWidget);
      expect(find.text('4/4'), findsOneWidget);
    });

    testWidgets('완료 버튼 탭 시 onCompleted 콜백을 호출한다', (WidgetTester tester) async {
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScreen(
            onCompleted: () {
              completed = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('수학'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, '다음'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('완료'));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
    });
  });
}
