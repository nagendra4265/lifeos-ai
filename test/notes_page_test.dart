import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/features/notes/presentation/pages/notes_page.dart';

void main() {
  testWidgets('can add a note from the notes page', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: NotesPage())),
    );

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Trip to Hampi');
    await tester.enterText(
      find.byType(TextField).at(1),
      'Capture the route and food stops',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Trip to Hampi'), findsOneWidget);
  });
}
