import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/features/dashboard/presentation/pages/dashboard_page.dart';

void main() {
  testWidgets('dashboard shows quick actions and summary cards', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    expect(find.text('Quick actions'), findsOneWidget);
    expect(find.text('AI suggestions'), findsOneWidget);
    expect(
      find.text('Review your insurance renewal next week'),
      findsOneWidget,
    );
  });
}
