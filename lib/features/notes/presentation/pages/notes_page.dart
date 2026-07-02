import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<_NoteItem> _notes = [
    const _NoteItem(
      title: 'Trip plan to Goa',
      body: 'AI summary ready. 3 tags. Voice note attached.',
      icon: Icons.beach_access_rounded,
      tag: 'Personal',
      color: Color(0xFF3D5AFE),
      pinned: true,
    ),
    const _NoteItem(
      title: 'Project Ideas',
      body: 'New feature list for the LifeOS dashboard.',
      icon: Icons.lightbulb_rounded,
      tag: 'Work',
      color: Color(0xFFFFB547),
    ),
    const _NoteItem(
      title: 'Daily Thoughts',
      body: 'A short reflection from last night.',
      icon: Icons.edit_note_rounded,
      tag: 'Journal',
      color: Color(0xFFFF4AA2),
    ),
  ];

  String _query = '';
  String _selectedFilter = 'All';

  Future<void> _showNoteEditor() async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final tagController = TextEditingController(text: 'Personal');

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New note'),
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

                setState(() {
                  _notes.insert(
                    0,
                    _NoteItem(
                      title: title,
                      body: body,
                      icon: Icons.note_alt_rounded,
                      tag: tagController.text.trim().isEmpty
                          ? 'Personal'
                          : tagController.text.trim(),
                      color: lifeOsPurple,
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showNoteDetails(_NoteItem note) {
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
                note.tag,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: lifeOsMuted),
              ),
              const SizedBox(height: 12),
              Text(note.body),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Close'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
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
    final filteredNotes = _notes.where((note) {
      final matchesSearch =
          _query.isEmpty ||
          note.title.toLowerCase().contains(_query) ||
          note.body.toLowerCase().contains(_query) ||
          note.tag.toLowerCase().contains(_query);

      final matchesFilter = switch (_selectedFilter) {
        'Pinned' => note.pinned,
        'Tasks' => note.tag.toLowerCase() == 'work',
        _ => true,
      };

      return matchesSearch && matchesFilter;
    }).toList();

    return LifeOsPage(
      title: 'Notes',
      subtitle: 'Capture ideas, plans, and quick thoughts',
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert_rounded),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNoteEditor,
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
          children: compact
              ? const [
                  LifeOsMetricCard(
                    title: 'Notes',
                    value: '12',
                    subtitle: 'Saved',
                    icon: Icons.sticky_note_2_rounded,
                    color: Color(0xFF6D4CFF),
                  ),
                  LifeOsMetricCard(
                    title: 'Pinned',
                    value: '3',
                    subtitle: 'Important',
                    icon: Icons.push_pin_rounded,
                    color: Color(0xFFFF4AA2),
                  ),
                ]
              : const [
                  LifeOsMetricCard(
                    title: 'Notes',
                    value: '12',
                    subtitle: 'Saved',
                    icon: Icons.sticky_note_2_rounded,
                    color: Color(0xFF6D4CFF),
                  ),
                  LifeOsMetricCard(
                    title: 'Pinned',
                    value: '3',
                    subtitle: 'Important',
                    icon: Icons.push_pin_rounded,
                    color: Color(0xFFFF4AA2),
                  ),
                  LifeOsMetricCard(
                    title: 'Tasks',
                    value: '4',
                    subtitle: 'Action items',
                    icon: Icons.checklist_rounded,
                    color: Color(0xFF18A058),
                  ),
                ],
        ),
        LifeOsSearchField(
          hintText: 'Search notes...',
          onChanged: (value) =>
              setState(() => _query = value.trim().toLowerCase()),
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
            ChoiceChip(
              selected: _selectedFilter == 'Tasks',
              label: const Text('Tasks'),
              onSelected: (_) => setState(() => _selectedFilter = 'Tasks'),
            ),
          ],
        ),
        if (filteredNotes.isEmpty)
          LifeOsCard(
            child: Text(
              'No notes matched your search.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
        else
          ...filteredNotes.map(
            (note) => compact
                ? LifeOsCard(
                    onTap: () => _showNoteDetails(note),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: note.color.withValues(alpha: .12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                note.icon,
                                color: note.color,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                note.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                            Icon(
                              note.pinned
                                  ? Icons.push_pin_rounded
                                  : Icons.chevron_right_rounded,
                              size: 18,
                              color: lifeOsMuted,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          note.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: lifeOsMuted),
                        ),
                        const SizedBox(height: 10),
                        _TagPill(label: note.tag, color: note.color),
                      ],
                    ),
                  )
                : LifeOsListTile(
                    title: note.title,
                    subtitle: '${note.tag} • ${note.body}',
                    icon: note.icon,
                    color: note.color,
                    trailing: IconButton(
                      onPressed: () => _showNoteDetails(note),
                      icon: Icon(
                        note.pinned
                            ? Icons.push_pin_rounded
                            : Icons.chevron_right_rounded,
                      ),
                    ),
                    onTap: () => _showNoteDetails(note),
                  ),
          ),
      ],
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
