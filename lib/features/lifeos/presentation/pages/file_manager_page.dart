import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/providers/files_provider.dart';
import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class FileManagerPage extends ConsumerStatefulWidget {
  const FileManagerPage({super.key});

  @override
  ConsumerState<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends ConsumerState<FileManagerPage> {
  String _query = '';

  Future<void> _showFileMenu() async {
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
                  'File manager',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Organize uploads and storage.',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.upload_file_rounded),
                  title: const Text('Upload file'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _addFile();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.storage_rounded),
                  title: const Text('Storage details'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Storage details opened.')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addFile() async {
    final titleController = TextEditingController();
    final sizeController = TextEditingController(text: '2.4 MB');
    final typeController = TextEditingController(text: 'Images');
    
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add file'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'File name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: sizeController,
                decoration: const InputDecoration(labelText: 'Size'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Category (Images, Videos, etc.)'),
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

    ref.read(filesProvider.notifier).addFile(
      name: title,
      size: sizeController.text.trim(),
      type: typeController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    final filesAsync = ref.watch(filesProvider);

    return LifeOsPage(
      title: 'File Manager',
      trailing: IconButton(
        onPressed: _showFileMenu,
        icon: const Icon(Icons.more_vert_rounded),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFile,
        child: const Icon(Icons.add),
      ),
      children: [
        LifeOsSearchField(
          hintText: 'Search files...',
          onChanged: (value) =>
              setState(() => _query = value.trim().toLowerCase()),
        ),
        GridView.count(
          crossAxisCount: compact ? 2 : 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: compact ? 1.05 : 1,
          children: const [
            _FolderTile(label: 'Images', icon: Icons.image_rounded, color: Color(0xFFFFB547)),
            _FolderTile(label: 'Videos', icon: Icons.videocam_rounded, color: Color(0xFF6D4CFF)),
            _FolderTile(label: 'Audio', icon: Icons.music_note_rounded, color: Color(0xFFFF4AA2)),
            _FolderTile(label: 'Documents', icon: Icons.description_rounded, color: Color(0xFF3D5AFE)),
            _FolderTile(label: 'Downloads', icon: Icons.download_rounded, color: Color(0xFF18A058)),
            _FolderTile(label: 'Archives', icon: Icons.archive_rounded, color: Color(0xFFFF7A45)),
          ],
        ),
        filesAsync.when(
          data: (files) {
            final filtered = files.where((f) =>
              _query.isEmpty ||
              f.name.toLowerCase().contains(_query) ||
              f.type.toLowerCase().contains(_query)
            ).toList();

            return Column(
              children: [
                if (filtered.isEmpty)
                  const LifeOsCard(child: Center(child: Text('No files found.')))
                else
                  ...filtered.map((file) => LifeOsListTile(
                    title: file.name,
                    subtitle: '${file.size} • ${file.type}',
                    icon: _getIconForType(file.type),
                    color: lifeOsPurple,
                    trailing: IconButton(
                      onPressed: () => ref.read(filesProvider.notifier).deleteFile(file.id),
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    ),
                  )),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, st) => Text('Error: $err'),
        ),
      ],
    );
  }

  IconData _getIconForType(String type) {
    return switch (type.toLowerCase()) {
      'images' => Icons.image_rounded,
      'videos' => Icons.videocam_rounded,
      'audio' => Icons.music_note_rounded,
      'documents' => Icons.description_rounded,
      _ => Icons.insert_drive_file_rounded,
    };
  }
}

class _FolderTile extends StatelessWidget {
  const _FolderTile({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LifeOsCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
