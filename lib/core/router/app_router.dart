import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_application_1/core/widgets/app_shell.dart';
import 'package:flutter_application_1/features/assistant/presentation/pages/assistant_page.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_application_1/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter_application_1/features/documents/presentation/pages/documents_detail_page.dart';
import 'package:flutter_application_1/features/documents/presentation/pages/documents_page.dart';
import 'package:flutter_application_1/features/expenses/presentation/pages/expenses_page.dart';
import 'package:flutter_application_1/features/lifeos/presentation/pages/lifeos_pages.dart';
import 'package:flutter_application_1/features/notes/presentation/pages/notes_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) => AppRouter(ref).router);

class AppRouter {
  AppRouter(this.ref);

  final Ref ref;

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(initialPage: 1),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const LoginPage(initialPage: 0),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const LoginPage(initialPage: 2),
      ),
      GoRoute(
        path: '/face-id',
        builder: (context, state) => const LoginPage(initialPage: 3),
      ),
      GoRoute(
        path: '/intro',
        builder: (context, state) => const LoginPage(initialPage: 4),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/assistant',
                builder: (context, state) => const AssistantPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/documents',
                builder: (context, state) => const DocumentsPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return DocumentsDetailPage(documentId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/expenses',
                builder: (context, state) => const ExpensesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notes',
                builder: (context, state) => const NotesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                builder: (context, state) => const CalendarPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/health',
                builder: (context, state) => const HealthPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/passwords',
                builder: (context, state) => const PasswordsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/journal',
                builder: (context, state) => const JournalPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/memories',
                builder: (context, state) => const MemoriesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tasks',
                builder: (context, state) => const TasksPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/files',
                builder: (context, state) => const FileManagerPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/contacts',
                builder: (context, state) => const ContactsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reminders',
                builder: (context, state) => const RemindersPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/premium',
                builder: (context, state) => const PremiumPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
