import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/note.dart';
import 'package:flutter_application_1/core/providers/notes_provider.dart';

import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  String _query = '';
  String _selectedFilter = 'All';

  Future<void> _showNoteEditor({Note? note}) async {
    final titleController = TextEditingController(text: note?.title);
    final bodyController = TextEditingController(text: note?.content);
    final tagController = TextEditingController(
      text: note?.tags?.isNotEmpty == true ? note!.tags!.first : 'Personal',
    );

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note == null ? 'New note' : 'Edit note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: tagController,
                  decoration: const InputDecoration(labelText: 'Tag'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bodyController,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Details'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final title = titleController.text.trim();
                final body = bodyController.text.trim();
                if (title.isEmpty || body.isEmpty) return;

                if (note == null) {
                  ref.read(notesProvider.notifier).addNote(
                    title: title,
                    content: body,
                  );
                } else {
                  ref.read(notesProvider.notifier).updateNote(
                    note.copyWith(
                      title: title,
                      content: body,
                      tags: [tagController.text.trim()],
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showNoteDetails(Note note) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                note.tags?.join(', ') ?? 'No tags',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: lifeOsMuted),
              ),
              const SizedBox(height: 12),
              Text(note.content),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Close'),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ref.read(notesProvider.notifier).deleteNote(note.id);
                    },
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showNoteEditor(note: note);
                    },
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Edit'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    final notesAsync = ref.watch(notesProvider);

    return notesAsync.when(
      data: (notes) {
        final filteredNotes = notes.where((note) {
          final matchesSearch = _query.isEmpty ||
              note.title.toLowerCase().contains(_query) ||
              note.content.toLowerCase().contains(_query);

          final matchesFilter = switch (_selectedFilter) {
            'Pinned' => note.isPinned,
            _ => true,
          };

          return matchesSearch && matchesFilter;
        }).toList();

        return LifeOsPage(
          title: 'Notes',
          subtitle: 'Capture ideas, plans, and quick thoughts',
          trailing: IconButton(
            onPressed: () {}, // Removed static actions for now
            icon: const Icon(Icons.more_vert_rounded),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showNoteEditor(),
            child: const Icon(Icons.add),
          ),
          children: [
            GridView.count(
              crossAxisCount: compact ? 2 : 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: compact ? 1.8 : 2.25,
              children: [
                LifeOsMetricCard(
                  title: 'Notes',
                  value: notes.length.toString(),
                  subtitle: 'Saved',
                  icon: Icons.sticky_note_2_rounded,
                  color: const Color(0xFF6D4CFF),
                ),
                LifeOsMetricCard(
                  title: 'Pinned',
                  value: notes.where((n) => n.isPinned).length.toString(),
                  subtitle: 'Important',
                  icon: Icons.push_pin_rounded,
                  color: const Color(0xFFFF4AA2),
                ),
                if (!compact)
                  const LifeOsMetricCard(
                    title: 'Tasks',
                    value: '0',
                    subtitle: 'Linked',
                    icon: Icons.checklist_rounded,
                    color: Color(0xFF18A058),
                  ),
              ],
            ),
            LifeOsSearchField(
              hintText: 'Search notes...',
              onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  selected: _selectedFilter == 'All',
                  label: const Text('All'),
                  onSelected: (_) => setState(() => _selectedFilter = 'All'),
                ),
                ChoiceChip(
                  selected: _selectedFilter == 'Pinned',
                  label: const Text('Pinned'),
                  onSelected: (_) => setState(() => _selectedFilter = 'Pinned'),
                ),
              ],
            ),
            if (filteredNotes.isEmpty)
              LifeOsEmptyState(
                title: notes.isEmpty ? 'No notes yet' : 'No results found',
                subtitle: notes.isEmpty ? 'Capture your first thought or plan now.' : 'Try searching for something else.',
                icon: Icons.notes_rounded,
                actionLabel: notes.isEmpty ? 'Create Note' : null,
                onAction: () => _showNoteEditor(),
              )
            else
              ...filteredNotes.map(
                (note) => LifeOsListTile(
                  title: note.title,
                  subtitle: note.content,
                  icon: Icons.note_alt_rounded,
                  color: lifeOsPurple,
                  trailing: note.isPinned ? const Icon(Icons.push_pin_rounded, size: 18) : const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showNoteDetails(note),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _NoteItem {
  const _NoteItem({
    required this.title,
    required this.body,
    required this.icon,
    required this.tag,
    required this.color,
    this.pinned = false,
  });

  final String title;
  final String body;
  final IconData icon;
  final String tag;
  final Color color;
  final bool pinned;
}
