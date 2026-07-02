import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('LifeOS AI launches with the splash screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LifeOsApp()));

    expect(find.text('LifeOS AI'), findsWidgets);
    expect(find.textContaining('Enhanced by AI'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
