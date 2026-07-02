import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'Good Morning, Arjun',
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
                      children: const [
                        Expanded(flex: 3, child: _MainOverview()),
                        SizedBox(width: 16),
                        SizedBox(width: 300, child: _RightRail()),
                      ],
                    )
                  else ...[
                    const _MainOverview(),
                    const SizedBox(height: 16),
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
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
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.auto_awesome_rounded),
        ),
        IconButton(
          onPressed: () => context.go('/settings'),
          icon: const Icon(Icons.settings_outlined),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Add New'),
        ),
      ],
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final cards = const [
      LifeOsMetricCard(
        title: 'Tasks',
        value: '12',
        subtitle: 'Pending',
        icon: Icons.checklist_rounded,
        color: Color(0xFFFF8A00),
      ),
      LifeOsMetricCard(
        title: 'Expenses',
        value: '₹2,450',
        subtitle: 'Today',
        icon: Icons.account_balance_wallet_rounded,
        color: Color(0xFF18A058),
      ),
      LifeOsMetricCard(
        title: 'Events',
        value: '5',
        subtitle: 'Today',
        icon: Icons.calendar_month_rounded,
        color: Color(0xFF6D4CFF),
      ),
      LifeOsMetricCard(
        title: 'Health Score',
        value: '86',
        subtitle: 'Good',
        icon: Icons.monitor_heart_rounded,
        color: Color(0xFFFF4AA2),
      ),
      LifeOsMetricCard(
        title: 'Documents',
        value: '12',
        subtitle: 'Expiring soon',
        icon: Icons.description_rounded,
        color: Color(0xFFFF7A45),
      ),
    ];

    return GridView.count(
      crossAxisCount: wide ? 5 : 2,
      childAspectRatio: wide ? 1.55 : 1.45,
      shrinkWrap: true,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      children: cards,
    );
  }
}

class _MainOverview extends StatelessWidget {
  const _MainOverview();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 900) {
      return const Column(
        children: [
          _MonthlyOverview(),
          SizedBox(height: 14),
          _ReminderPanel(),
          SizedBox(height: 14),
          _AiSuggestions(),
        ],
      );
    }

    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _MonthlyOverview()),
        SizedBox(width: 14),
        Expanded(
          child: Column(
            children: [
              _ReminderPanel(),
              SizedBox(height: 14),
              _AiSuggestions(),
            ],
          ),
        ),
      ],
    );
  }
}

class _MonthlyOverview extends StatelessWidget {
  const _MonthlyOverview();

  @override
  Widget build(BuildContext context) {
    return LifeOsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LifeOsSectionTitle(
            title: 'Monthly Overview',
            action: 'May 2024',
          ),
          const SizedBox(height: 18),
          Text(
            'Total Expenses',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: lifeOsMuted),
          ),
          const SizedBox(height: 4),
          Text(
            '₹48,650',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            '-18.6% vs Apr 2024',
            style: TextStyle(
              color: Color(0xFFFF4AA2),
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
                  children: const [
                    _Legend(
                      label: 'Food & Dining',
                      value: '32%',
                      color: Color(0xFF6D4CFF),
                    ),
                    _Legend(
                      label: 'Transport',
                      value: '18%',
                      color: Color(0xFFFF4AA2),
                    ),
                    _Legend(
                      label: 'Shopping',
                      value: '15%',
                      color: Color(0xFF18A058),
                    ),
                    _Legend(
                      label: 'Bills & Utilities',
                      value: '12%',
                      color: Color(0xFFFFB547),
                    ),
                    _Legend(
                      label: 'Health',
                      value: '8%',
                      color: Color(0xFF00A8FF),
                    ),
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

class _ReminderPanel extends StatelessWidget {
  const _ReminderPanel();

  @override
  Widget build(BuildContext context) {
    return LifeOsCard(
      child: Column(
        children: const [
          LifeOsSectionTitle(title: 'Upcoming Reminders'),
          SizedBox(height: 12),
          LifeOsListTile(
            title: 'Car Insurance Renewal',
            subtitle: 'May 20, 2024',
            icon: Icons.car_crash_rounded,
            color: Color(0xFFFF4AA2),
          ),
          SizedBox(height: 10),
          LifeOsListTile(
            title: 'Doctor Appointment',
            subtitle: 'May 21, 2024 - 11:00 AM',
            icon: Icons.local_hospital_rounded,
            color: Color(0xFF3D5AFE),
          ),
          SizedBox(height: 10),
          LifeOsListTile(
            title: 'Passport Expiry',
            subtitle: 'Jun 12, 2024',
            icon: Icons.badge_rounded,
            color: Color(0xFFFFB547),
          ),
        ],
      ),
    );
  }
}

class _AiSuggestions extends StatelessWidget {
  const _AiSuggestions();

  @override
  Widget build(BuildContext context) {
    return LifeOsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          LifeOsSectionTitle(title: 'AI suggestions'),
          SizedBox(height: 12),
          LifeOsListTile(
            title: 'Review your insurance renewal next week',
            subtitle: 'You spent more on food this month. Want to see why?',
            icon: Icons.lightbulb_outline_rounded,
            color: Color(0xFF6D4CFF),
          ),
          SizedBox(height: 10),
          LifeOsListTile(
            title: '2 documents are expiring soon',
            subtitle: 'Passport and insurance need attention.',
            icon: Icons.description_outlined,
            color: Color(0xFF8B5CF6),
          ),
          SizedBox(height: 10),
          LifeOsListTile(
            title: 'Your sugar levels are normal',
            subtitle: 'Keep it up.',
            icon: Icons.health_and_safety_outlined,
            color: Color(0xFF18A058),
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
      children: const [_MiniCalendar(), SizedBox(height: 14), _RecentNotes()],
    );
  }
}

class _MiniCalendar extends StatelessWidget {
  const _MiniCalendar();

  @override
  Widget build(BuildContext context) {
    return LifeOsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          LifeOsSectionTitle(title: 'Calendar'),
          SizedBox(height: 12),
          LifeOsListTile(
            title: 'Doctor Appointment',
            subtitle: '11:00 AM - 12:00 PM',
            icon: Icons.local_hospital_rounded,
            color: Color(0xFF6D4CFF),
          ),
          SizedBox(height: 10),
          LifeOsListTile(
            title: 'Team Standup',
            subtitle: '02:00 - 03:00 PM',
            icon: Icons.groups_rounded,
            color: Color(0xFFFF7A45),
          ),
          SizedBox(height: 10),
          LifeOsListTile(
            title: 'Dinner with Rahul',
            subtitle: '08:00 - 10:00 PM',
            icon: Icons.restaurant_rounded,
            color: Color(0xFFFF4AA2),
          ),
        ],
      ),
    );
  }
}

class _RecentNotes extends StatelessWidget {
  const _RecentNotes();

  @override
  Widget build(BuildContext context) {
    return LifeOsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          LifeOsSectionTitle(title: 'Recent Notes', action: 'View All'),
          SizedBox(height: 12),
          LifeOsListTile(
            title: 'Goa Trip Plan',
            subtitle: '2h ago',
            icon: Icons.note_alt_rounded,
            color: Color(0xFFFFB547),
          ),
          SizedBox(height: 10),
          LifeOsListTile(
            title: 'Project Ideas',
            subtitle: '1d ago',
            icon: Icons.lightbulb_outline_rounded,
            color: Color(0xFF3D5AFE),
          ),
          SizedBox(height: 10),
          LifeOsListTile(
            title: 'Daily Thoughts',
            subtitle: '2d ago',
            icon: Icons.edit_note_rounded,
            color: Color(0xFF6D4CFF),
          ),
        ],
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
