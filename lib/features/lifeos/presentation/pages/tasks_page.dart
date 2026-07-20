import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/providers/tasks_provider.dart';
import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  String _selectedFilter = 'All';

  Future<void> _showTaskMenu() async {
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
                  'Task actions',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Create and organize tasks.',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.add_rounded),
                  title: const Text('New task'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _addTask();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.filter_alt_rounded),
                  title: const Text('Clear filters'),
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

  Future<void> _addTask() async {
    final titleController = TextEditingController();
    final dueController = TextEditingController(text: 'Today');
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dueController,
                decoration: const InputDecoration(labelText: 'Due'),
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
    
    ref.read(tasksProvider.notifier).addTask(
      title: title,
      subtitle: dueController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksProvider);

    return tasksAsync.when(
      data: (tasks) {
        final visibleTasks = _selectedFilter == 'All'
            ? tasks
            : tasks.where((task) {
                if (_selectedFilter == 'Done') return task.isCompleted;
                return task.subtitle?.toLowerCase().contains(_selectedFilter.toLowerCase()) ?? false;
              }).toList();

        return LifeOsPage(
          title: 'Tasks',
          trailing: IconButton(
            onPressed: _showTaskMenu,
            icon: const Icon(Icons.more_vert_rounded),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _addTask,
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
                  selected: _selectedFilter == 'Today',
                  label: const Text('Today'),
                  onSelected: (_) => setState(() => _selectedFilter = 'Today'),
                ),
                ChoiceChip(
                  selected: _selectedFilter == 'Done',
                  label: const Text('Done'),
                  onSelected: (_) => setState(() => _selectedFilter = 'Done'),
                ),
              ],
            ),
            if (visibleTasks.isEmpty)
              LifeOsEmptyState(
                title: 'No tasks found',
                subtitle: _selectedFilter == 'All' ? 'Start organizing your day by adding your first task.' : 'Try clearing your filters to see more tasks.',
                icon: Icons.checklist_rounded,
                actionLabel: _selectedFilter == 'All' ? 'Add Task' : null,
                onAction: _addTask,
              )
            else
              ...visibleTasks.map(
                (task) => LifeOsListTile(
                  title: task.title,
                  subtitle: task.subtitle ?? 'No due date',
                  icon: task.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: task.isCompleted ? Colors.green : lifeOsPurple,
                  trailing: IconButton(
                    onPressed: () => ref.read(tasksProvider.notifier).deleteTask(task.id),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  ),
                  onTap: () => ref.read(tasksProvider.notifier).toggleTask(task),
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
