import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _items = [
    _ShellItem('Dashboard', Icons.dashboard_outlined, Icons.dashboard_rounded),
    _ShellItem(
      'AI Assistant',
      Icons.auto_awesome_outlined,
      Icons.auto_awesome_rounded,
    ),
    _ShellItem('Notes', Icons.notes_outlined, Icons.notes_rounded),
    _ShellItem(
      'Expenses',
      Icons.receipt_long_outlined,
      Icons.receipt_long_rounded,
    ),
    _ShellItem(
      'Documents',
      Icons.folder_open_outlined,
      Icons.folder_open_rounded,
    ),
    _ShellItem(
      'Calendar',
      Icons.calendar_month_outlined,
      Icons.calendar_month_rounded,
    ),
    _ShellItem(
      'Health',
      Icons.favorite_outline_rounded,
      Icons.favorite_rounded,
    ),
    _ShellItem('Passwords', Icons.lock_outline_rounded, Icons.lock_rounded),
    _ShellItem('Journal', Icons.edit_note_outlined, Icons.edit_note_rounded),
    _ShellItem(
      'Memories',
      Icons.photo_library_outlined,
      Icons.photo_library_rounded,
    ),
    _ShellItem('Tasks', Icons.checklist_rounded, Icons.checklist_rounded),
    _ShellItem('Files', Icons.folder_copy_outlined, Icons.folder_copy_rounded),
    _ShellItem('Contacts', Icons.contacts_outlined, Icons.contacts_rounded),
    _ShellItem(
      'Reminders',
      Icons.notifications_none_rounded,
      Icons.notifications_rounded,
    ),
    _ShellItem('Settings', Icons.settings_outlined, Icons.settings_rounded),
    _ShellItem(
      'Premium',
      Icons.workspace_premium_outlined,
      Icons.workspace_premium_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            _SideMenu(
              selectedIndex: navigationShell.currentIndex,
              onSelected: _goBranch,
            ),
            const VerticalDivider(width: 1, color: lifeOsBorder),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    final current = navigationShell.currentIndex;
    final selectedIndex = current < 5 ? current : 0;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: selectedIndex,
        onDestinationSelected: _goBranch,
        destinations: _items.take(5).map((item) {
          return NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _SideMenu extends StatelessWidget {
  const _SideMenu({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 232,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF12172A), Color(0xFF20204E)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 19,
                    backgroundColor: Color(0xFFFFD2B8),
                    child: Text(
                      'A',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF5C2E16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Arjun Sharma',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        Text(
                          'Premium Plan',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: const Color(0xFFFFD166)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                itemCount: AppShell._items.length,
                itemBuilder: (context, index) {
                  final item = AppShell._items[index];
                  final selected = index == selectedIndex;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => onSelected(index),
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: selected ? lifeOsPurple : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              selected ? item.selectedIcon : item.icon,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withValues(
                                    alpha: selected ? 1 : .86,
                                  ),
                                  fontWeight: selected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white54,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: TextButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFFF7A91),
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Color(0xFFFF7A91)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShellItem {
  const _ShellItem(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
