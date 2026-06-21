import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odab_ddokddok/app/router.dart';

void main() {
  group('App Router', () {
    test('router is defined with all routes', () {
      final router = createRouter();
      expect(router, isNotNull);
      expect(router.routerDelegate, isNotNull);
    });

    testWidgets('app renders with MaterialApp', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            title: 'OdabDdokDdok',
            routerConfig: createRouter(),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
          ),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('initial route is home', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createRouter(),
            theme: ThemeData(useMaterial3: true),
          ),
        ),
      );

      await tester.pumpAndSettle();
      // Home screen should be rendered
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('scan route renders gallery import action', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createRouter(initialLocation: '/scan'),
            theme: ThemeData(useMaterial3: true),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('스캔'), findsOneWidget);
      expect(find.text('갤러리에서 가져오기'), findsOneWidget);
    });
  });
}
