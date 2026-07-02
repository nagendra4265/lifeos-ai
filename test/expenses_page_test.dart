import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/features/expenses/presentation/pages/expenses_page.dart';

void main() {
  testWidgets('can add an expense entry', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ExpensesPage()));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Lunch');
    await tester.enterText(find.byType(TextField).at(1), '250');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Lunch'), findsOneWidget);
    expect(find.text('₹250'), findsOneWidget);
  });
}
