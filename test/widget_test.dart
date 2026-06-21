import 'package:flutter_test/flutter_test.dart';

import 'package:odab_ddokddok/main.dart';

void main() {
  testWidgets('bootstrap text is shown', (WidgetTester tester) async {
    await tester.pumpWidget(const OdabDdokDdokApp());
    await tester.pumpAndSettle();

    // HomeScreen should be rendered
    expect(find.text('오답똑똑'), findsOneWidget);
  });
}
