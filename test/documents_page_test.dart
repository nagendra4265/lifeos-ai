import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_application_1/features/documents/presentation/pages/documents_page.dart';
import 'package:flutter_application_1/features/documents/presentation/pages/documents_detail_page.dart';

void main() {
  testWidgets('opens document upload bottom sheet', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: DocumentsPage())),
    );

    await tester.tap(find.byIcon(Icons.upload_file_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Import document'), findsOneWidget);
    expect(find.text('Save document'), findsOneWidget);
  });

  testWidgets('saves document from upload form and shows it in list', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: DocumentsPage())),
    );

    await tester.tap(find.byIcon(Icons.upload_file_rounded));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('documentTitleField')),
      'Travel Permit',
    );
    await tester.enterText(
      find.byKey(const Key('documentHolderField')),
      'Arjun Singh',
    );
    await tester.enterText(
      find.byKey(const Key('documentNumberField')),
      'TP-2026-01',
    );
    await tester.enterText(
      find.byKey(const Key('documentIssuedField')),
      '2026-06-15',
    );
    await tester.enterText(
      find.byKey(const Key('documentExpiryField')),
      '2028-06-15',
    );
    await tester.enterText(
      find.byKey(const Key('documentOcrField')),
      'Permit ID: TP-2026-01',
    );

    await tester.pumpAndSettle();
    final saveButton = find.byKey(const Key('saveDocumentButton'));
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Travel Permit'), findsOneWidget);
    expect(find.text('Expires 2028-06-15'), findsOneWidget);
  });

  testWidgets('filters document list by search query', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: DocumentsPage())),
    );

    await tester.enterText(
      find.byKey(const Key('documentSearchField')),
      'passport',
    );
    await tester.pumpAndSettle();

    expect(find.text('Passport'), findsOneWidget);
    expect(find.text('Health Insurance'), findsNothing);
  });

  testWidgets(
    'uploads document with OCR text and preserves it in detail view',
    (tester) async {
      final router = GoRouter(
        initialLocation: '/documents',
        routes: [
          GoRoute(
            path: '/documents',
            builder: (context, state) => const DocumentsPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => DocumentsDetailPage(
                  documentId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      await tester.tap(find.byIcon(Icons.upload_file_rounded));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('documentTitleField')),
        'Travel Permit',
      );
      await tester.enterText(
        find.byKey(const Key('documentHolderField')),
        'Arjun Singh',
      );
      await tester.enterText(
        find.byKey(const Key('documentNumberField')),
        'TP-2026-01',
      );
      await tester.enterText(
        find.byKey(const Key('documentIssuedField')),
        '2026-06-15',
      );
      await tester.enterText(
        find.byKey(const Key('documentExpiryField')),
        '2028-06-15',
      );
      await tester.enterText(
        find.byKey(const Key('documentOcrField')),
        'Permit ID: TP-2026-01',
      );

      await tester.pumpAndSettle();
      final saveButton = find.byKey(const Key('saveDocumentButton'));
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Travel Permit'), findsOneWidget);

      await tester.tap(find.text('Travel Permit'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Document details'), findsOneWidget);
      expect(find.text('Permit ID: TP-2026-01'), findsOneWidget);
    },
  );

  testWidgets('filters document list by category chip', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: DocumentsPage())),
    );

    await tester.tap(find.byKey(const Key('documentCategoryChip_Identity')));
    await tester.pumpAndSettle();

    expect(find.text('Passport'), findsOneWidget);
    expect(find.text('Health Insurance'), findsNothing);
  });

  testWidgets(
    'filters document list by favorites after marking a document favorite',
    (tester) async {
      final router = GoRouter(
        initialLocation: '/documents',
        routes: [
          GoRoute(
            path: '/documents',
            builder: (context, state) => const DocumentsPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => DocumentsDetailPage(
                  documentId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Passport'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('favoriteDocumentButton')));
      await tester.pumpAndSettle();

      router.go('/documents');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('documentCategoryChip_Favorites')));
      await tester.pumpAndSettle();

      expect(find.text('Passport'), findsOneWidget);
      expect(find.text('Health Insurance'), findsNothing);
    },
  );

  testWidgets('filters archived documents after archiving from detail page', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/documents',
      routes: [
        GoRoute(
          path: '/documents',
          builder: (context, state) => const DocumentsPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) =>
                  DocumentsDetailPage(documentId: state.pathParameters['id']!),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Passport'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('archiveDocumentButton')));
    await tester.pumpAndSettle();

    router.go('/documents');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('documentCategoryChip_Archived')));
    await tester.pumpAndSettle();

    expect(find.text('Passport'), findsOneWidget);
    expect(find.text('Health Insurance'), findsNothing);
  });

  testWidgets('filters document list by OCR or metadata search', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: DocumentsPage())),
    );

    await tester.enterText(
      find.byKey(const Key('documentSearchField')),
      'machine-readable',
    );
    await tester.pumpAndSettle();

    expect(find.text('Passport'), findsOneWidget);
    expect(find.text('Health Insurance'), findsNothing);
  });

  testWidgets('changes expiry sort order when toggle button is pressed', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: DocumentsPage())),
    );

    expect(
      find.descendant(
        of: find.byType(ListView),
        matching: find.text('Passport'),
      ),
      findsOneWidget,
    );

    expect(
      tester.widgetList<ListTile>(find.byType(ListTile)).first.title,
      isA<Text>().having((t) => t.data, 'title', 'Passport'),
    );

    await tester.tap(find.byKey(const Key('expirySortToggleButton')));
    await tester.pumpAndSettle();

    final firstTileAfterToggle = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .first;
    expect((firstTileAfterToggle.title as Text).data, 'Health Insurance');
  });

  testWidgets('navigates from documents list to document details', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/documents',
      routes: [
        GoRoute(
          path: '/documents',
          builder: (context, state) => const DocumentsPage(),
        ),
        GoRoute(
          path: '/documents/:id',
          builder: (context, state) =>
              DocumentsDetailPage(documentId: state.pathParameters['id']!),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Passport'));
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Document details'),
      ),
      findsOneWidget,
    );
    expect(find.text('X1234567'), findsOneWidget);
  });
}
