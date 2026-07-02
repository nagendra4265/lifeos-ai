import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_application_1/features/documents/presentation/pages/documents_detail_page.dart';
import 'package:flutter_application_1/features/documents/presentation/pages/documents_page.dart';

void main() {
  testWidgets('document detail page shows OCR metadata and preview', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: DocumentsDetailPage(documentId: 'passport')),
      ),
    );

    expect(find.text('Passport'), findsOneWidget);
    expect(find.text('Document number'), findsOneWidget);
    expect(find.text('X1234567'), findsOneWidget);
    expect(
      find.text(
        'Official passport scan with machine-readable zone (MRZ) and identity fields extracted by OCR.',
      ),
      findsOneWidget,
    );
    expect(find.text('Analyze OCR data'), findsOneWidget);
  });

  testWidgets('cancels delete document when confirmation is dismissed', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/documents/passport',
      routes: [
        GoRoute(
          path: '/documents',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Documents list placeholder')),
          ),
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

    expect(find.text('Passport'), findsOneWidget);
    await tester.tap(find.byKey(const Key('deleteDocumentButton')));
    await tester.pumpAndSettle();

    expect(find.text('Delete document'), findsOneWidget);
    await tester.tap(find.byKey(const Key('cancelDeleteButton')));
    await tester.pumpAndSettle();

    expect(find.text('Passport'), findsOneWidget);
    expect(find.text('Documents list placeholder'), findsNothing);
  });

  testWidgets('copies OCR text to clipboard from detail page', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: DocumentsDetailPage(documentId: 'passport')),
      ),
    );

    final copyButton = find.byKey(const Key('copyOcrTextButton'));
    expect(copyButton, findsOneWidget);
    await tester.ensureVisible(copyButton);
    await tester.tap(copyButton);
    await tester.pumpAndSettle();

    expect(find.text('OCR text copied to clipboard.'), findsOneWidget);
  });

  testWidgets('edits an existing document from detail page', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: DocumentsDetailPage(documentId: 'passport')),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('editDocumentButton')));
    await tester.pumpAndSettle();

    expect(find.text('Edit document'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('editDocumentTitleField')),
      'Passport Updated',
    );
    await tester.tap(find.byKey(const Key('saveEditedDocumentButton')));
    await tester.pumpAndSettle();

    expect(find.text('Passport Updated'), findsOneWidget);
    expect(find.text('Passport'), findsNothing);
  });

  testWidgets('duplicates a document from detail page', (tester) async {
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
    await tester.tap(find.byKey(const Key('duplicateDocumentButton')));
    await tester.pumpAndSettle();

    router.go('/documents');
    await tester.pumpAndSettle();

    expect(find.text('Passport (Copy)'), findsOneWidget);
  });

  testWidgets('favorites a document from detail page', (tester) async {
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
    await tester.tap(find.byKey(const Key('favoriteDocumentButton')));
    await tester.pumpAndSettle();

    expect(find.text('Passport added to favorites.'), findsOneWidget);
  });

  testWidgets('shares document details from detail page', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: DocumentsDetailPage(documentId: 'passport')),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('shareDocumentButton')));
    await tester.pumpAndSettle();

    expect(find.text('Document details copied for sharing.'), findsOneWidget);
  });

  testWidgets('exports document details from detail page', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: DocumentsDetailPage(documentId: 'passport')),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('exportDocumentButton')));
    await tester.pumpAndSettle();

    expect(find.text('Document exported to clipboard.'), findsOneWidget);
  });

  testWidgets('sets an expiry reminder from detail page', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: DocumentsDetailPage(documentId: 'passport')),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('remindDocumentButton')));
    await tester.pumpAndSettle();

    expect(
      find.text('Reminder set for Passport before expiry.'),
      findsOneWidget,
    );
  });

  testWidgets(
    'archives a document from detail page and hides it from active list',
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
      await tester.tap(find.byKey(const Key('archiveDocumentButton')));
      await tester.pumpAndSettle();

      expect(find.text('Passport archived.'), findsOneWidget);
      expect(find.text('Passport'), findsNothing);

      await tester.tap(find.byKey(const Key('documentCategoryChip_Archived')));
      await tester.pumpAndSettle();

      expect(find.text('Passport'), findsOneWidget);
    },
  );

  testWidgets('pins a document from detail page and surfaces it in the list', (
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
    await tester.tap(find.byKey(const Key('pinDocumentButton')));
    await tester.pumpAndSettle();

    router.go('/documents');
    await tester.pumpAndSettle();

    expect(find.text('Passport pinned.'), findsOneWidget);
    expect(find.byIcon(Icons.push_pin_rounded), findsOneWidget);
  });

  testWidgets('deletes document from detail page after confirmation', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/documents/passport',
      routes: [
        GoRoute(
          path: '/documents',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Documents list placeholder')),
          ),
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

    expect(find.text('Passport'), findsOneWidget);
    await tester.tap(find.byKey(const Key('deleteDocumentButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirmDeleteButton')));
    await tester.pumpAndSettle();

    expect(find.text('Documents list placeholder'), findsOneWidget);
    expect(find.text('Passport'), findsNothing);
  });
}
