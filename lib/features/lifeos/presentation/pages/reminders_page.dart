import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/core/providers/reminders_provider.dart';
import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class RemindersPage extends ConsumerStatefulWidget {
  const RemindersPage({super.key});

  @override
  ConsumerState<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends ConsumerState<RemindersPage> {
  String _selectedFilter = 'All';

  Future<void> _showReminderMenu() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reminder actions',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Keep alerts on track.',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.add_alarm_rounded),
                  title: const Text('Add reminder'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _addReminder();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.filter_alt_off_rounded),
                  title: const Text('Show all reminders'),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() => _selectedFilter = 'All');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addReminder() async {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController(text: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()));
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Reminder'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(labelText: 'When (yyyy-MM-dd HH:mm)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (saved != true) return;
    final title = titleController.text.trim();
    if (title.isEmpty) return;
    
    final dateTime = DateFormat('yyyy-MM-dd HH:mm').tryParse(subtitleController.text.trim()) ?? DateTime.now();

    ref.read(remindersProvider.notifier).addReminder(
      title: title,
      dateTime: dateTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    final remindersAsync = ref.watch(remindersProvider);

    return remindersAsync.when(
      data: (reminders) {
        final filteredReminders = reminders.where((item) {
          if (_selectedFilter == 'All') return true;
          if (_selectedFilter == 'Medicine') return item.title.toLowerCase().contains('medicine');
          return true;
        }).toList();

        return LifeOsPage(
          title: 'Reminders',
          trailing: IconButton(
            onPressed: _showReminderMenu,
            icon: const Icon(Icons.more_vert_rounded),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _addReminder,
            child: const Icon(Icons.add),
          ),
          children: [
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  selected: _selectedFilter == 'All',
                  label: const Text('All'),
                  onSelected: (_) => setState(() => _selectedFilter = 'All'),
                ),
                ChoiceChip(
                  selected: _selectedFilter == 'Medicine',
                  label: const Text('Medicine'),
                  onSelected: (_) => setState(() => _selectedFilter = 'Medicine'),
                ),
              ],
            ),
            if (filteredReminders.isEmpty)
              const LifeOsCard(child: Center(child: Text('No reminders found.')))
            else
              ...filteredReminders.map(
                (item) => LifeOsListTile(
                  title: item.title,
                  subtitle: DateFormat('MMM dd, yyyy - hh:mm a').format(item.dateTime),
                  icon: Icons.notifications_active_rounded,
                  color: Colors.orangeAccent,
                  trailing: IconButton(
                    onPressed: () => ref.read(remindersProvider.notifier).deleteReminder(item.id),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err')),
    );
  }
}
