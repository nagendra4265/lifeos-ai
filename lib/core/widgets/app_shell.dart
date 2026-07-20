import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/providers/user_profile_provider.dart';
import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const items = [
    _ShellItem('Dashboard', Icons.dashboard_outlined, Icons.dashboard_rounded),
    _ShellItem('AI Assistant', Icons.auto_awesome_outlined, Icons.auto_awesome_rounded),
    _ShellItem('Notes', Icons.notes_outlined, Icons.notes_rounded),
    _ShellItem('Expenses', Icons.receipt_long_outlined, Icons.receipt_long_rounded),
    _ShellItem('Documents', Icons.folder_open_outlined, Icons.folder_open_rounded),
    _ShellItem('Calendar', Icons.calendar_month_outlined, Icons.calendar_month_rounded),
    _ShellItem('Health', Icons.favorite_outline_rounded, Icons.favorite_rounded),
    _ShellItem('Passwords', Icons.lock_outline_rounded, Icons.lock_rounded),
    _ShellItem('Journal', Icons.edit_note_outlined, Icons.edit_note_rounded),
    _ShellItem('Memories', Icons.photo_library_outlined, Icons.photo_library_rounded),
    _ShellItem('Tasks', Icons.checklist_rounded, Icons.checklist_rounded),
    _ShellItem('Files', Icons.folder_copy_outlined, Icons.folder_copy_rounded),
    _ShellItem('Contacts', Icons.contacts_outlined, Icons.contacts_rounded),
    _ShellItem('Reminders', Icons.notifications_none_rounded, Icons.notifications_rounded),
    _ShellItem('Settings', Icons.settings_outlined, Icons.settings_rounded),
    _ShellItem('Premium', Icons.workspace_premium_outlined, Icons.workspace_premium_rounded),
  ];

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            _SideMenu(
              selectedIndex: _sidebarIndexForBranch(widget.navigationShell.currentIndex),
              onSelected: _goBranchFromSidebar,
            ),
            const VerticalDivider(width: 1, color: lifeOsBorder),
            Expanded(child: widget.navigationShell),
          ],
        ),
      );
    }

    final current = widget.navigationShell.currentIndex;
    final selectedIndex = switch (current) {
      0 => 0,
      1 => 1,
      4 => 2,
      2 => 3,
      _ => 4,
    };

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: selectedIndex,
        onDestinationSelected: _goBranch,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome_rounded), label: 'Assistant'),
          NavigationDestination(icon: Icon(Icons.notes_outlined), selectedIcon: Icon(Icons.notes_rounded), label: 'Notes'),
          NavigationDestination(icon: Icon(Icons.folder_open_outlined), selectedIcon: Icon(Icons.folder_open_rounded), label: 'Documents'),
          NavigationDestination(icon: Icon(Icons.apps_outlined), selectedIcon: Icon(Icons.apps_rounded), label: 'More'),
        ],
      ),
    );
  }

  void _goBranch(int index) {
    if (index == 4) {
      _showMoreSheet(context);
      return;
    }
    final branchIndex = switch (index) {
      0 => 0,
      1 => 1,
      2 => 4,
      3 => 2,
      _ => 0,
    };
    widget.navigationShell.goBranch(branchIndex, initialLocation: branchIndex == widget.navigationShell.currentIndex);
  }

  void _goBranchFromSidebar(int index) {
    final branchIndex = _branchIndexForSidebar(index);
    if (branchIndex == null) return;
    widget.navigationShell.goBranch(branchIndex, initialLocation: branchIndex == widget.navigationShell.currentIndex);
  }

  int? _branchIndexForSidebar(int index) => index < 16 ? index : null;

  int _sidebarIndexForBranch(int branchIndex) => branchIndex;

  void _showMoreSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('More', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('Open the rest of LifeOS', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: lifeOsMuted)),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.18,
                  children: [
                    _MoreTile(label: 'Expenses', icon: Icons.receipt_long_rounded, color: const Color(0xFF18A058), onTap: () => _goAndClose(context, 3)),
                    _MoreTile(label: 'Calendar', icon: Icons.calendar_month_rounded, color: const Color(0xFF6D4CFF), onTap: () => _goAndClose(context, 5)),
                    _MoreTile(label: 'Health', icon: Icons.favorite_rounded, color: const Color(0xFFFF4AA2), onTap: () => _goAndClose(context, 6)),
                    _MoreTile(label: 'Passwords', icon: Icons.lock_rounded, color: const Color(0xFFFF7A45), onTap: () => _goAndClose(context, 7)),
                    _MoreTile(label: 'Journal', icon: Icons.edit_note_rounded, color: const Color(0xFF3D5AFE), onTap: () => _goAndClose(context, 8)),
                    _MoreTile(label: 'Memories', icon: Icons.photo_library_rounded, color: const Color(0xFF00A88F), onTap: () => _goAndClose(context, 9)),
                    _MoreTile(label: 'Tasks', icon: Icons.checklist_rounded, color: const Color(0xFFFFB547), onTap: () => _goAndClose(context, 10)),
                    _MoreTile(label: 'Files', icon: Icons.folder_copy_rounded, color: const Color(0xFF6D4CFF), onTap: () => _goAndClose(context, 11)),
                    _MoreTile(label: 'Contacts', icon: Icons.contacts_rounded, color: const Color(0xFFFF4AA2), onTap: () => _goAndClose(context, 12)),
                    _MoreTile(label: 'Reminders', icon: Icons.notifications_rounded, color: const Color(0xFF18A058), onTap: () => _goAndClose(context, 13)),
                    _MoreTile(label: 'Settings', icon: Icons.settings_rounded, color: const Color(0xFF3D5AFE), onTap: () => _goAndClose(context, 14)),
                    _MoreTile(label: 'Premium', icon: Icons.workspace_premium_rounded, color: const Color(0xFF6D4CFF), onTap: () => _goAndClose(context, 15)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _goAndClose(BuildContext context, int branchIndex) {
    Navigator.of(context).pop();
    widget.navigationShell.goBranch(branchIndex, initialLocation: branchIndex == widget.navigationShell.currentIndex);
  }
}

class _SideMenu extends ConsumerWidget {
  const _SideMenu({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    return Container(
      width: 232,
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF12172A), Color(0xFF20204E)]),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 19,
                    backgroundColor: const Color(0xFFFFD2B8),
                    child: Text(profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'A', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF5C2E16))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                        Text(profile.plan, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFFFFD166))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                itemCount: AppShell.items.length,
                itemBuilder: (context, index) {
                  final item = AppShell.items[index];
                  final selected = index == selectedIndex;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => onSelected(index),
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: selected ? lifeOsPurple : Colors.transparent, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Icon(selected ? item.selectedIcon : item.icon, color: Colors.white, size: 20),
                            const SizedBox(width: 10),
                            Expanded(child: Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white.withValues(alpha: selected ? 1 : .86), fontWeight: selected ? FontWeight.w800 : FontWeight.w600, fontSize: 13))),
                            const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 16),
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
                icon: const Icon(Icons.logout_rounded, color: Color(0xFFFF7A91)),
                label: const Text('Logout', style: TextStyle(color: Color(0xFFFF7A91))),
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

class _MoreTile extends StatelessWidget {
  const _MoreTile({required this.label, required this.icon, required this.color, required this.onTap});
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return LifeOsCard(
      onTap: onTap,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 20)),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
