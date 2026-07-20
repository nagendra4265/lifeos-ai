import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/core/providers/memories_provider.dart';
import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class MemoriesPage extends ConsumerWidget {
  const MemoriesPage({super.key});

  Future<void> _showMemoriesMenu(BuildContext context, WidgetRef ref) async {
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
                  'Memories actions',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Browse and save life moments.',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.add_photo_alternate_rounded),
                  title: const Text('Add memory'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _addMemory(context, ref);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addMemory(BuildContext context, WidgetRef ref) async {
    final titleController = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Memory'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'What happened?'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    );

    if (saved == true && titleController.text.isNotEmpty) {
      ref.read(memoriesProvider.notifier).addMemory(title: titleController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoriesAsync = ref.watch(memoriesProvider);

    return LifeOsPage(
      title: 'Memories',
      trailing: IconButton(
        onPressed: () => _showMemoriesMenu(context, ref),
        icon: const Icon(Icons.more_vert_rounded),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMemory(context, ref),
        child: const Icon(Icons.add),
      ),
      children: [
        const LifeOsSearchField(hintText: 'Search memories...'),
        memoriesAsync.when(
          data: (memories) {
            if (memories.isEmpty) {
              return const LifeOsCard(child: Center(child: Text('No memories yet. Capture a moment!')));
            }
            return Column(
              children: memories.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MemoryAlbum(
                  title: m.title,
                  date: DateFormat('MMM yyyy').format(m.date),
                  colors: const [Colors.blue, Colors.purple],
                  onDelete: () => ref.read(memoriesProvider.notifier).deleteMemory(m.id),
                ),
              )).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, st) => Text('Error: $err'),
        ),
      ],
    );
  }
}

class _MemoryAlbum extends StatelessWidget {
  const _MemoryAlbum({
    required this.title,
    required this.date,
    required this.colors,
    this.onDelete,
  });

  final String title;
  final String date;
  final List<Color> colors;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return LifeOsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                date,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: lifeOsMuted),
              ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded, size: 16),
                ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Container(
                  height: 90,
                  margin: EdgeInsets.only(right: index == 2 ? 0 : 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors[index % colors.length].withValues(alpha: 0.7),
                        colors[(index + 1) % colors.length],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
