import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<_NoteItem> _notes = [
    const _NoteItem(
      title: 'Trip plan to Goa',
      body: 'AI summary ready • 3 tags • voice note attached',
      icon: Icons.note_alt_rounded,
    ),
    const _NoteItem(
      title: 'Receipts from last week',
      body: 'OCR ready • searchable by amount and merchant',
      icon: Icons.image_rounded,
    ),
  ];

  Future<void> _showNoteEditor() async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bodyController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Details'),
              ),
            ],
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
                if (title.isEmpty || body.isEmpty) {
                  return;
                }

                setState(() {
                  _notes.insert(
                    0,
                    _NoteItem(
                      title: title,
                      body: body,
                      icon: Icons.note_alt_rounded,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNoteEditor,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(note.icon),
              title: Text(note.title),
              subtitle: Text(note.body),
            ),
          );
        },
      ),
    );
  }
}

class _NoteItem {
  const _NoteItem({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;
}
