import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/core/providers/reminders_provider.dart';
import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _selectedDate = DateTime.now();

  String _monthLabel(DateTime value) {
    return DateFormat('MMMM yyyy').format(value);
  }

  String _selectedLabel(DateTime value) {
    return DateFormat('EEE, MMM dd').format(value);
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  Future<void> _showCalendarMenu() async {
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
                  'Calendar actions',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Manage your schedule from here.',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.today_rounded),
                  title: const Text('Go to today'),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      final now = DateTime.now();
                      _focusedMonth = DateTime(now.year, now.month, 1);
                      _selectedDate = now;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_rounded),
                  title: const Text('Add reminder'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showAddReminderSheet();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddReminderSheet() async {
    final titleController = TextEditingController();
    final timeController = TextEditingController(text: '09:00 AM');

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
                'Add reminder',
                style: Theme.of(
                  sheetContext,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Time'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () {
                      final title = titleController.text.trim();
                      if (title.isEmpty) return;
                      
                      final timeParts = timeController.text.split(':');
                      int hour = 9;
                      if (timeParts.isNotEmpty) hour = int.tryParse(timeParts[0]) ?? 9;

                      ref.read(remindersProvider.notifier).addReminder(
                        title: title,
                        dateTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, hour),
                      );
                      
                      Navigator.of(sheetContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reminder saved for ${_selectedLabel(_selectedDate)}.')),
                      );
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildCalendarCells(bool compact) {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final leadingEmpty = (firstDay.weekday - 1) % 7;
    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
    );
    final totalCells = ((leadingEmpty + daysInMonth + 6) ~/ 7) * 7;
    return List.generate(totalCells, (index) {
      if (index < leadingEmpty || index >= leadingEmpty + daysInMonth) {
        return const SizedBox.shrink();
      }
      final day = index - leadingEmpty + 1;
      final current = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final selected =
          current.year == _selectedDate.year &&
          current.month == _selectedDate.month &&
          current.day == _selectedDate.day;
      
      return InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => setState(() => _selectedDate = current),
        child: Center(
          child: Container(
            width: compact ? 32 : 34,
            height: compact ? 32 : 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? lifeOsPurple : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$day',
              style: TextStyle(
                color: selected ? Colors.white : lifeOsInk,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    final reminders = ref.watch(remindersProvider).valueOrNull ?? [];
    final selectedDayEvents = reminders.where((r) => 
      r.dateTime.year == _selectedDate.year &&
      r.dateTime.month == _selectedDate.month &&
      r.dateTime.day == _selectedDate.day
    ).toList();

    return LifeOsPage(
      title: 'Calendar',
      subtitle: 'Schedule - ${_selectedLabel(_selectedDate)}',
      trailing: IconButton(
        onPressed: _showCalendarMenu,
        icon: const Icon(Icons.more_vert_rounded),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReminderSheet,
        child: const Icon(Icons.add),
      ),
      children: [
        LifeOsCard(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _goToPreviousMonth,
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _monthLabel(_focusedMonth),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _goToNextMonth,
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 7,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: compact ? 0.92 : 1,
                children: _buildCalendarCells(compact),
              ),
            ],
          ),
        ),
        if (selectedDayEvents.isEmpty)
          LifeOsCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'No events scheduled for this day.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                ),
              ),
            ),
          )
        else
          ...selectedDayEvents.map((e) => LifeOsListTile(
            title: e.title,
            subtitle: DateFormat('hh:mm a').format(e.dateTime),
            icon: Icons.notifications_active_rounded,
            color: Colors.orangeAccent,
            trailing: IconButton(
              onPressed: () => ref.read(remindersProvider.notifier).deleteReminder(e.id),
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
            ),
          )),
      ],
    );
  }
}
