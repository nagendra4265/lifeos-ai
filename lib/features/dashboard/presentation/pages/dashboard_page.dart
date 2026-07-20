import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/providers/tasks_provider.dart';
import 'package:flutter_application_1/core/providers/expenses_provider.dart';
import 'package:flutter_application_1/core/providers/notes_provider.dart';
import 'package:flutter_application_1/core/providers/reminders_provider.dart';
import 'package:flutter_application_1/core/providers/user_profile_provider.dart';
import 'package:flutter_application_1/core/providers/memories_provider.dart';
import 'package:flutter_application_1/features/documents/data/documents_notifier.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

Future<void> _showDashboardSearchSheet(BuildContext context) async {
  final queryController = TextEditingController();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          8,
          20,
          20 + MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search LifeOS',
              style: Theme.of(
                sheetContext,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Jump into a section or look up something quickly.',
              style: Theme.of(
                sheetContext,
              ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: queryController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search notes, documents, tasks...',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.auto_awesome_rounded, size: 18),
                  label: const Text('Assistant'),
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    context.go('/assistant');
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.notes_rounded, size: 18),
                  label: const Text('Notes'),
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    context.go('/notes');
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.folder_open_rounded, size: 18),
                  label: const Text('Documents'),
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    context.go('/documents');
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.checklist_rounded, size: 18),
                  label: const Text('Tasks'),
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    context.go('/tasks');
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

void _showDashboardSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
}

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 980;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopBar(wide: wide),
                  const SizedBox(height: 18),
                  Text(
                    'Today\'s Focus',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: lifeOsPurple,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_getGreeting()}, ${profile.name.split(' ')[0]}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Here is what is happening in your life today.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                  ),
                  const SizedBox(height: 18),
                  _SummaryGrid(wide: wide),
                  const SizedBox(height: 16),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: const _MainOverview()),
                        const SizedBox(width: 16),
                        const SizedBox(width: 300, child: _RightRail()),
                      ],
                    )
                  else ...[
                    const _MainOverview(),
                    const SizedBox(height: 20),
                    const LifeOsSectionTitle(title: 'Recent Memories'),
                    const SizedBox(height: 12),
                    const _RecentMemories(),
                    const SizedBox(height: 20),
                    const _RightRail(),
                  ],
                  const SizedBox(height: 16),
                  const LifeOsSectionTitle(title: 'Quick actions'),
                  const SizedBox(height: 12),
                  _QuickAccessGrid(wide: wide),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    if (!wide) {
      return Row(
        children: [
          const LifeOsGradientIcon(size: 42),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'LifeOS AI',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          IconButton(
            onPressed: () => _showDashboardSearchSheet(context),
            icon: const Icon(Icons.search_rounded),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 'settings') {
                context.go('/settings');
              } else if (value == 'assistant') {
                context.go('/assistant');
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'assistant', child: Text('AI Assistant')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        SizedBox(
          width: 320,
          child: LifeOsSearchField(hintText: 'Search anything...'),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => _showDashboardSnack(
            context,
            'Notifications and smart alerts will open here.',
          ),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        IconButton(
          onPressed: () => _showDashboardSearchSheet(context),
          icon: const Icon(Icons.auto_awesome_rounded),
        ),
        IconButton(
          onPressed: () => context.go('/settings'),
          icon: const Icon(Icons.settings_outlined),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () => _showDashboardSearchSheet(context),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Add New'),
        ),
      ],
    );
  }
}

class _SummaryGrid extends ConsumerWidget {
  const _SummaryGrid({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider).valueOrNull ?? [];
    final expenses = ref.watch(expensesProvider).valueOrNull ?? [];
    final reminders = ref.watch(remindersProvider).valueOrNull ?? [];
    
    final todayExpenses = expenses.where((e) => 
      e.date.day == DateTime.now().day && 
      e.date.month == DateTime.now().month && 
      e.date.year == DateTime.now().year
    ).fold<double>(0, (sum, e) => sum + e.amount);

    return GridView.count(
      crossAxisCount: wide ? 5 : 2,
      childAspectRatio: wide ? 1.55 : 1.45,
      shrinkWrap: true,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        LifeOsMetricCard(
          title: 'Tasks',
          value: tasks.where((t) => !t.isCompleted).length.toString(),
          subtitle: 'Pending',
          icon: Icons.checklist_rounded,
          color: const Color(0xFFFF8A00),
        ),
        LifeOsMetricCard(
          title: 'Expenses',
          value: NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0).format(todayExpenses),
          subtitle: 'Today',
          icon: Icons.account_balance_wallet_rounded,
          color: const Color(0xFF18A058),
        ),
        LifeOsMetricCard(
          title: 'Reminders',
          value: reminders.length.toString(),
          subtitle: 'Active',
          icon: Icons.notifications_active_rounded,
          color: const Color(0xFF6D4CFF),
        ),
        const LifeOsMetricCard(
          title: 'Health Score',
          value: '86',
          subtitle: 'Good',
          icon: Icons.monitor_heart_rounded,
          color: Color(0xFFFF4AA2),
        ),
        const LifeOsMetricCard(
          title: 'Documents',
          value: '12',
          subtitle: 'Expiring soon',
          icon: Icons.description_rounded,
          color: Color(0xFFFF7A45),
        ),
      ],
    );
  }
}

class _MainOverview extends StatelessWidget {
  const _MainOverview();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 900) {
      return Column(
        children: [
          const _MonthlyOverview(),
          const SizedBox(height: 14),
          const _ReminderPanel(),
          const SizedBox(height: 14),
          const _AiSuggestions(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: const _MonthlyOverview()),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            children: [
              const _ReminderPanel(),
              const SizedBox(height: 14),
              const _AiSuggestions(),
            ],
          ),
        ),
      ],
    );
  }
}

class _MonthlyOverview extends ConsumerWidget {
  const _MonthlyOverview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider).valueOrNull ?? [];
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;
    
    final monthlyExpenses = expenses.where((e) => 
      e.date.month == currentMonth && e.date.year == currentYear
    ).toList();
    
    final total = monthlyExpenses.fold<double>(0, (sum, e) => sum + e.amount);
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return LifeOsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LifeOsSectionTitle(
            title: 'Monthly Overview',
            action: DateFormat('MMM yyyy').format(DateTime.now()),
          ),
          const SizedBox(height: 18),
          Text(
            'Total Expenses',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: lifeOsMuted),
          ),
          const SizedBox(height: 4),
          Text(
            formatter.format(total),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Live tracking enabled',
            style: TextStyle(
              color: Color(0xFF18A058),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const LifeOsDonutChart(
                colors: [
                  Color(0xFF6D4CFF),
                  Color(0xFFFF4AA2),
                  Color(0xFF18A058),
                  Color(0xFFFFB547),
                  Color(0xFF00A8FF),
                  Color(0xFFFF7A45),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _Legend(label: 'Transactions', value: monthlyExpenses.length.toString(), color: const Color(0xFF6D4CFF)),
                    const _Legend(label: 'Trend', value: 'Updating...', color: Color(0xFFFF4AA2)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () => context.go('/expenses'),
              child: const Text('View Report'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: lifeOsMuted),
          ),
        ],
      ),
    );
  }
}

class _ReminderPanel extends ConsumerWidget {
  const _ReminderPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(remindersProvider).valueOrNull ?? [];
    final display = reminders.take(3).toList();

    return LifeOsCard(
      child: Column(
        children: [
          LifeOsSectionTitle(
            title: 'Upcoming Reminders',
            action: 'View All',
            onTap: () => context.go('/reminders'),
          ),
          const SizedBox(height: 12),
          if (display.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('No reminders.'),
            ))
          else
            ...display.map((reminder) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: LifeOsListTile(
                title: reminder.title,
                subtitle: DateFormat('MMM dd, hh:mm a').format(reminder.dateTime),
                icon: Icons.notifications_active_rounded,
                color: const Color(0xFFFF4AA2),
                onTap: () => context.go('/reminders'),
              ),
            )),
        ],
      ),
    );
  }
}

class _AiSuggestions extends ConsumerWidget {
  const _AiSuggestions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider).valueOrNull ?? [];
    final expenses = ref.watch(expensesProvider).valueOrNull ?? [];
    final reminders = ref.watch(remindersProvider).valueOrNull ?? [];
    
    final pendingTasks = tasks.where((t) => !t.isCompleted).length;
    final totalSpent = expenses.fold<double>(0, (sum, e) => sum + e.amount);
    final overdueReminders = reminders.where((r) => r.dateTime.isBefore(DateTime.now())).length;

    return LifeOsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LifeOsSectionTitle(title: 'AI suggestions'),
          const SizedBox(height: 12),
          if (pendingTasks > 0)
            LifeOsListTile(
              title: 'You have $pendingTasks pending tasks',
              subtitle: 'Focus on your highest priority items today.',
              icon: Icons.auto_awesome_rounded,
              color: const Color(0xFF6D4CFF),
              onTap: () => context.go('/tasks'),
            ),
          if (overdueReminders > 0)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: LifeOsListTile(
                title: '$overdueReminders items need attention',
                subtitle: 'Check your reminders for overdue events.',
                icon: Icons.priority_high_rounded,
                color: Colors.orangeAccent,
                onTap: () => context.go('/reminders'),
              ),
            ),
          if (pendingTasks == 0 && overdueReminders == 0)
            const LifeOsListTile(
              title: 'Everything is on track',
              subtitle: 'You are all caught up for now.',
              icon: Icons.check_circle_outline_rounded,
              color: Color(0xFF18A058),
            ),
          const SizedBox(height: 10),
          if (totalSpent > 10000)
            LifeOsListTile(
              title: 'Spending Alert',
              subtitle: 'You\'ve spent ${NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0).format(totalSpent)} this month.',
              icon: Icons.insights_rounded,
              color: const Color(0xFF8B5CF6),
              onTap: () => context.go('/expenses'),
            )
          else
            LifeOsListTile(
              title: 'Healthy Budget',
              subtitle: 'Your spending is well within limits.',
              icon: Icons.savings_rounded,
              color: const Color(0xFF00B8FF),
              onTap: () => context.go('/expenses'),
            ),
        ],
      ),
    );
  }
}

class _RightRail extends StatelessWidget {
  const _RightRail();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_MiniCalendar(), const SizedBox(height: 14), _RecentNotes()],
    );
  }
}

class _MiniCalendar extends ConsumerWidget {
  const _MiniCalendar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(remindersProvider).valueOrNull ?? [];
    final today = reminders.where((r) => 
      r.dateTime.day == DateTime.now().day && 
      r.dateTime.month == DateTime.now().month && 
      r.dateTime.year == DateTime.now().year
    ).toList();

    return LifeOsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LifeOsSectionTitle(
            title: 'Calendar', 
            action: 'View All',
            onTap: () => context.go('/calendar'),
          ),
          const SizedBox(height: 12),
          if (today.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('No events today.'),
            ))
          else
            ...today.take(3).map((event) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: LifeOsListTile(
                title: event.title,
                subtitle: DateFormat('hh:mm a').format(event.dateTime),
                icon: Icons.calendar_today_rounded,
                color: const Color(0xFF6D4CFF),
                onTap: () => context.go('/calendar'),
              ),
            )),
        ],
      ),
    );
  }
}

class _RecentNotes extends ConsumerWidget {
  const _RecentNotes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider).valueOrNull ?? [];
    final recent = notes.toList()..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final display = recent.take(3).toList();

    return LifeOsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LifeOsSectionTitle(
            title: 'Recent Notes', 
            action: 'View All',
            onTap: () => context.go('/notes'),
          ),
          const SizedBox(height: 12),
          if (display.isEmpty)
            const Center(child: Text('No notes yet.'))
          else
            ...display.map((note) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: LifeOsListTile(
                title: note.title,
                subtitle: _formatRelativeDate(note.updatedAt),
                icon: Icons.note_alt_rounded,
                color: const Color(0xFFFFB547),
                onTap: () => context.go('/notes'),
              ),
            )),
        ],
      ),
    );
  }

  String _formatRelativeDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _RecentMemories extends ConsumerWidget {
  const _RecentMemories();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memories = ref.watch(memoriesProvider).valueOrNull ?? [];
    if (memories.isEmpty) {
      return LifeOsCard(
        onTap: () => context.go('/memories'),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('No memories yet. Tap to add one!'),
          ),
        ),
      );
    }

    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: memories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final memory = memories[index];
          return Container(
            width: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  lifeOsPurple.withValues(alpha: .7),
                  lifeOsIndigo,
                ],
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                const Spacer(),
                Text(
                  memory.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM yyyy').format(memory.date),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickAccess('AI Assistant', Icons.auto_awesome_rounded, '/assistant'),
      _QuickAccess('Add Note', Icons.note_add_rounded, '/notes'),
      _QuickAccess('New Expense', Icons.receipt_long_rounded, '/expenses'),
      _QuickAccess(
        'Scan Document',
        Icons.document_scanner_rounded,
        '/documents',
      ),
      _QuickAccess('Calendar', Icons.calendar_month_rounded, '/calendar'),
      _QuickAccess('Health', Icons.favorite_rounded, '/health'),
      _QuickAccess('Tasks', Icons.checklist_rounded, '/tasks'),
      _QuickAccess('Passwords', Icons.lock_rounded, '/passwords'),
      _QuickAccess('Memories', Icons.photo_library_rounded, '/memories'),
      _QuickAccess('File Manager', Icons.folder_copy_rounded, '/files'),
      _QuickAccess('Contacts', Icons.contacts_rounded, '/contacts'),
      _QuickAccess('Settings', Icons.settings_rounded, '/settings'),
    ];

    return GridView.count(
      crossAxisCount: wide ? 6 : 3,
      childAspectRatio: 1.15,
      shrinkWrap: true,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      children: items.map((item) {
        return LifeOsCard(
          onTap: () => context.go(item.path),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: lifeOsPurple),
              const SizedBox(height: 10),
              Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _QuickAccess {
  const _QuickAccess(this.label, this.icon, this.path);

  final String label;
  final IconData icon;
  final String path;
}
