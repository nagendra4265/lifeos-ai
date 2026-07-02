import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    return LifeOsPage(
      title: 'Calendar',
      subtitle: 'Today - Tue, May 21',
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert_rounded),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      children: [
        LifeOsCard(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'May 2024',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
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
                children: List.generate(35, (index) {
                  final day = index + 1;
                  final selected = day == 21;
                  return Center(
                    child: Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? lifeOsPurple : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$day',
                        style: TextStyle(
                          color: selected ? Colors.white : lifeOsInk,
                          fontWeight: selected
                              ? FontWeight.w800
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const LifeOsListTile(
          title: 'Doctor Appointment',
          subtitle: '11:00 AM - 12:00 PM',
          icon: Icons.local_hospital_rounded,
          color: Color(0xFF6D4CFF),
        ),
        const LifeOsListTile(
          title: 'Team Standup',
          subtitle: '02:00 - 03:00 PM',
          icon: Icons.groups_rounded,
          color: Color(0xFFFF7A45),
        ),
        const LifeOsListTile(
          title: 'Dinner with Rahul',
          subtitle: '08:00 - 10:00 PM',
          icon: Icons.restaurant_rounded,
          color: Color(0xFFFF4AA2),
        ),
      ],
    );
  }
}

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    return LifeOsPage(
      title: 'Health',
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert_rounded),
      ),
      children: [
        LifeOsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Health Score',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: lifeOsMuted),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '86',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(' /100'),
                  ),
                ],
              ),
              const Text(
                'Good',
                style: TextStyle(
                  color: Color(0xFF18A058),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const LifeOsLineSpark(color: Color(0xFF18A058)),
            ],
          ),
        ),
        GridView.count(
          crossAxisCount: compact ? 2 : 4,
          childAspectRatio: compact ? 1.25 : 1.45,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: const [
            LifeOsMetricCard(
              title: 'Heart Rate',
              value: '72 bpm',
              subtitle: 'Normal',
              icon: Icons.favorite_rounded,
              color: Color(0xFFFF4AA2),
            ),
            LifeOsMetricCard(
              title: 'Blood Pressure',
              value: '120/80',
              subtitle: 'Normal',
              icon: Icons.monitor_heart_rounded,
              color: Color(0xFF6D4CFF),
            ),
            LifeOsMetricCard(
              title: 'Blood Sugar',
              value: '98 mg/dL',
              subtitle: 'Normal',
              icon: Icons.bloodtype_rounded,
              color: Color(0xFFFF7A45),
            ),
            LifeOsMetricCard(
              title: 'Weight',
              value: '68 kg',
              subtitle: 'Normal',
              icon: Icons.scale_rounded,
              color: Color(0xFF3D5AFE),
            ),
          ],
        ),
      ],
    );
  }
}

class PasswordsPage extends StatefulWidget {
  const PasswordsPage({super.key});

  @override
  State<PasswordsPage> createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  final List<_PasswordItem> _items = [
    const _PasswordItem(
      title: 'Google',
      subtitle: 'arjun@gmail.com',
      icon: Icons.g_mobiledata_rounded,
      color: Color(0xFF4285F4),
    ),
    const _PasswordItem(
      title: 'Facebook',
      subtitle: 'arjun@gmail.com',
      icon: Icons.facebook_rounded,
      color: Color(0xFF1877F2),
    ),
    const _PasswordItem(
      title: 'Instagram',
      subtitle: 'arjun_25',
      icon: Icons.camera_alt_rounded,
      color: Color(0xFFE4405F),
    ),
    const _PasswordItem(
      title: 'Amazon',
      subtitle: 'arjun@gmail.com',
      icon: Icons.shopping_bag_rounded,
      color: Color(0xFFFF9900),
    ),
    const _PasswordItem(
      title: 'Netflix',
      subtitle: 'arjun@gmail.com',
      icon: Icons.movie_rounded,
      color: Color(0xFFE50914),
    ),
  ];

  String _query = '';

  Future<void> _addPassword() async {
    final siteController = TextEditingController();
    final usernameController = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: siteController,
                decoration: const InputDecoration(labelText: 'Site'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
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
    final site = siteController.text.trim();
    if (site.isEmpty) return;
    setState(() {
      _items.insert(
        0,
        _PasswordItem(
          title: site,
          subtitle: usernameController.text.trim().isEmpty
              ? 'Saved in vault'
              : usernameController.text.trim(),
          icon: Icons.lock_rounded,
          color: lifeOsPurple,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    final filtered = _items
        .where(
          (item) =>
              _query.isEmpty ||
              item.title.toLowerCase().contains(_query) ||
              item.subtitle.toLowerCase().contains(_query),
        )
        .toList();

    return LifeOsPage(
      title: 'Passwords',
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert_rounded),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPassword,
        child: const Icon(Icons.add),
      ),
      children: [
        LifeOsSearchField(
          hintText: 'Search passwords...',
          onChanged: (value) =>
              setState(() => _query = value.trim().toLowerCase()),
        ),
        ...filtered.map(
          (item) => compact
              ? LifeOsCard(
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(item.icon, color: item.color, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: lifeOsMuted),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                )
              : LifeOsListTile(
                  title: item.title,
                  subtitle: item.subtitle,
                  icon: item.icon,
                  color: item.color,
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
        ),
      ],
    );
  }
}

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    return LifeOsPage(
      title: 'Journal',
      subtitle: 'How was your day?',
      trailing: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.close_rounded),
      ),
      children: [
        LifeOsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'May 21, 2024',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: lifeOsMuted),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(compact ? 4 : 5, (index) {
                  return CircleAvatar(
                    radius: compact ? 16 : 18,
                    backgroundColor: const Color(0xFFFFF2D8),
                    child: Icon(
                      Icons.sentiment_satisfied_alt_rounded,
                      color: Colors.orange.shade600,
                      size: compact ? 18 : 20,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                minLines: compact ? 3 : 4,
                maxLines: compact ? 4 : 6,
                decoration: InputDecoration(
                  hintText:
                      'Had a productive day. Finished the project and went for a long walk in the evening.',
                  filled: true,
                  fillColor: const Color(0xFFF6F7FB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.mic_none_rounded),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.image_outlined),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined),
                  ),
                  const Spacer(),
                  FilledButton(onPressed: () {}, child: const Text('Save')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MemoriesPage extends StatelessWidget {
  const MemoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LifeOsPage(
      title: 'Memories',
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert_rounded),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      children: [
        const LifeOsSearchField(hintText: 'Search memories...'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            ChoiceChip(selected: true, label: Text('Places')),
            ChoiceChip(selected: false, label: Text('People')),
            ChoiceChip(selected: false, label: Text('Events')),
            ChoiceChip(selected: false, label: Text('Conversations')),
          ],
        ),
        _MemoryAlbum(
          title: 'Goa Trip',
          date: 'Nov 2023',
          colors: [Color(0xFF00A88F), Color(0xFFFFB547)],
        ),
        _MemoryAlbum(
          title: 'With Rahul',
          date: 'Oct 2023',
          colors: [Color(0xFF3D5AFE), Color(0xFFFF4AA2)],
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
  });

  final String title;
  final String date;
  final List<Color> colors;

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
                        colors[index % colors.length],
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

class FileManagerPage extends StatefulWidget {
  const FileManagerPage({super.key});

  @override
  State<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  final List<_FileItem> _recentFiles = [
    const _FileItem(
      title: 'IMG_2024_05_21.jpg',
      subtitle: '2.4 MB - Images',
      icon: Icons.image_rounded,
      color: Color(0xFF18A058),
    ),
    const _FileItem(
      title: 'Project Report.pdf',
      subtitle: '1.8 MB - Documents',
      icon: Icons.picture_as_pdf_rounded,
      color: Color(0xFFFF4AA2),
    ),
  ];

  String _query = '';

  Future<void> _addFile() async {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
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
                controller: subtitleController,
                decoration: const InputDecoration(labelText: 'Details'),
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

    setState(() {
      _recentFiles.insert(
        0,
        _FileItem(
          title: title,
          subtitle: subtitleController.text.trim().isEmpty
              ? 'Added to files'
              : subtitleController.text.trim(),
          icon: Icons.insert_drive_file_rounded,
          color: lifeOsPurple,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    final recentFiles = _recentFiles
        .where(
          (file) =>
              _query.isEmpty ||
              file.title.toLowerCase().contains(_query) ||
              file.subtitle.toLowerCase().contains(_query),
        )
        .toList();

    return LifeOsPage(
      title: 'File Manager',
      trailing: IconButton(
        onPressed: () {},
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
            _FolderTile(
              label: 'Images',
              icon: Icons.image_rounded,
              color: Color(0xFFFFB547),
            ),
            _FolderTile(
              label: 'Videos',
              icon: Icons.videocam_rounded,
              color: Color(0xFF6D4CFF),
            ),
            _FolderTile(
              label: 'Audio',
              icon: Icons.music_note_rounded,
              color: Color(0xFFFF4AA2),
            ),
            _FolderTile(
              label: 'Documents',
              icon: Icons.description_rounded,
              color: Color(0xFF3D5AFE),
            ),
            _FolderTile(
              label: 'Downloads',
              icon: Icons.download_rounded,
              color: Color(0xFF18A058),
            ),
            _FolderTile(
              label: 'Archives',
              icon: Icons.archive_rounded,
              color: Color(0xFFFF7A45),
            ),
          ],
        ),
        LifeOsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LifeOsSectionTitle(title: 'Storage Overview'),
              const SizedBox(height: 8),
              const Text('45 GB / 128 GB used'),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: .35,
                color: lifeOsPurple,
                backgroundColor: lifeOsPurple.withValues(alpha: .12),
              ),
            ],
          ),
        ),
        ...recentFiles.map(
          (file) => compact
              ? LifeOsCard(
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: file.color.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(file.icon, color: file.color, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              file.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              file.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: lifeOsMuted),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.more_vert_rounded),
                    ],
                  ),
                )
              : LifeOsListTile(
                  title: file.title,
                  subtitle: file.subtitle,
                  icon: file.icon,
                  color: file.color,
                  trailing: const Icon(Icons.more_vert_rounded),
                ),
        ),
      ],
    );
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

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<_TaskItem> _tasks = [
    const _TaskItem(
      title: 'Complete project report',
      subtitle: 'Today',
      icon: Icons.check_circle_outline_rounded,
      color: Color(0xFF18A058),
    ),
    const _TaskItem(
      title: 'Buy groceries',
      subtitle: 'Today',
      icon: Icons.shopping_cart_outlined,
      color: Color(0xFFFFB547),
    ),
    const _TaskItem(
      title: 'Workout',
      subtitle: 'Tomorrow',
      icon: Icons.fitness_center_rounded,
      color: Color(0xFF00A88F),
    ),
    const _TaskItem(
      title: 'Call with client',
      subtitle: 'May 23',
      icon: Icons.call_outlined,
      color: Color(0xFF6D4CFF),
    ),
    const _TaskItem(
      title: 'Passport renewal',
      subtitle: 'May 25',
      icon: Icons.card_membership_rounded,
      color: Color(0xFFFF4AA2),
    ),
  ];

  String _selectedFilter = 'All';

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
    setState(() {
      _tasks.insert(
        0,
        _TaskItem(
          title: title,
          subtitle: dueController.text.trim().isEmpty
              ? 'Today'
              : dueController.text.trim(),
          icon: Icons.check_circle_outline_rounded,
          color: lifeOsPurple,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    final visibleTasks = _selectedFilter == 'All'
        ? _tasks
        : _tasks
              .where(
                (task) => task.subtitle.toLowerCase().contains(
                  _selectedFilter.toLowerCase(),
                ),
              )
              .toList();

    return LifeOsPage(
      title: 'Tasks',
      trailing: IconButton(
        onPressed: () {},
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
              selected: _selectedFilter == 'Tomorrow',
              label: const Text('Upcoming'),
              onSelected: (_) => setState(() => _selectedFilter = 'Tomorrow'),
            ),
            ChoiceChip(
              selected: _selectedFilter == 'Done',
              label: const Text('Done'),
              onSelected: (_) => setState(() => _selectedFilter = 'Done'),
            ),
          ],
        ),
        ...visibleTasks.map(
          (task) => compact
              ? LifeOsCard(
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: task.color.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(task.icon, color: task.color, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              task.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: lifeOsMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : LifeOsListTile(
                  title: task.title,
                  subtitle: task.subtitle,
                  icon: task.icon,
                  color: task.color,
                ),
        ),
      ],
    );
  }
}

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final List<_ContactItem> _contacts = [
    const _ContactItem(
      title: 'Rahul Verma',
      subtitle: '+91 98765 43210',
      icon: Icons.person_rounded,
      color: Color(0xFFB08A63),
    ),
    const _ContactItem(
      title: 'Priya Sharma',
      subtitle: '+91 87654 32109',
      icon: Icons.person_rounded,
      color: Color(0xFF3D5AFE),
    ),
    const _ContactItem(
      title: 'Vikram Singh',
      subtitle: '+91 76543 21098',
      icon: Icons.person_rounded,
      color: Color(0xFFFF7A45),
    ),
    const _ContactItem(
      title: 'Sneha Patel',
      subtitle: '+91 65432 10987',
      icon: Icons.person_rounded,
      color: Color(0xFF18A058),
    ),
    const _ContactItem(
      title: 'Amit Kumar',
      subtitle: '+91 54321 09876',
      icon: Icons.person_rounded,
      color: Color(0xFF6D4CFF),
    ),
  ];

  String _query = '';

  Future<void> _addContact() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
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
    final name = nameController.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _contacts.insert(
        0,
        _ContactItem(
          title: name,
          subtitle: phoneController.text.trim().isEmpty
              ? 'Saved contact'
              : phoneController.text.trim(),
          icon: Icons.person_rounded,
          color: lifeOsPurple,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    final visibleContacts = _contacts
        .where(
          (contact) =>
              _query.isEmpty ||
              contact.title.toLowerCase().contains(_query) ||
              contact.subtitle.toLowerCase().contains(_query),
        )
        .toList();

    return LifeOsPage(
      title: 'Contacts',
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert_rounded),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        child: const Icon(Icons.add),
      ),
      children: [
        LifeOsSearchField(
          hintText: 'Search contacts...',
          onChanged: (value) =>
              setState(() => _query = value.trim().toLowerCase()),
        ),
        ...visibleContacts.map(
          (contact) => compact
              ? LifeOsCard(
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: contact.color.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          contact.icon,
                          color: contact.color,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contact.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              contact.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: lifeOsMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : LifeOsListTile(
                  title: contact.title,
                  subtitle: contact.subtitle,
                  icon: contact.icon,
                  color: contact.color,
                ),
        ),
      ],
    );
  }
}

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final List<_ReminderItem> _reminders = [
    const _ReminderItem(
      title: 'Car Insurance Renewal',
      subtitle: 'May 20, 2024',
      icon: Icons.car_crash_rounded,
      color: Color(0xFFFF4AA2),
      pill: '3 days left',
    ),
    const _ReminderItem(
      title: 'Doctor Appointment',
      subtitle: 'May 21, 2024 - 11:00 AM',
      icon: Icons.local_hospital_rounded,
      color: Color(0xFF3D5AFE),
      pill: '4 days left',
    ),
    const _ReminderItem(
      title: 'Take Medicine',
      subtitle: 'May 21, 2024 - 08:00 PM',
      icon: Icons.medication_rounded,
      color: Color(0xFFFF7A45),
    ),
    const _ReminderItem(
      title: 'Passport Expiry',
      subtitle: 'Jun 12, 2024',
      icon: Icons.badge_rounded,
      color: Color(0xFFFFB547),
      pill: '26 days left',
    ),
    const _ReminderItem(
      title: "Mum's Birthday",
      subtitle: 'May 25, 2024',
      icon: Icons.cake_rounded,
      color: Color(0xFFFF4AA2),
      pill: '8 days left',
    ),
  ];

  String _selectedFilter = 'All';

  Future<void> _addReminder() async {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController(text: 'Today');
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
                decoration: const InputDecoration(labelText: 'When'),
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
    setState(() {
      _reminders.insert(
        0,
        _ReminderItem(
          title: title,
          subtitle: subtitleController.text.trim().isEmpty
              ? 'Today'
              : subtitleController.text.trim(),
          icon: Icons.notifications_none_rounded,
          color: lifeOsPurple,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    final reminders = _reminders.where((item) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Scheduled') return item.pill != null;
      if (_selectedFilter == 'Medicine') {
        return item.title.toLowerCase().contains('medicine');
      }
      return true;
    }).toList();

    return LifeOsPage(
      title: 'Reminders',
      trailing: IconButton(
        onPressed: () {},
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
              selected: _selectedFilter == 'Scheduled',
              label: const Text('Scheduled'),
              onSelected: (_) => setState(() => _selectedFilter = 'Scheduled'),
            ),
            ChoiceChip(
              selected: _selectedFilter == 'Medicine',
              label: const Text('Medicine'),
              onSelected: (_) => setState(() => _selectedFilter = 'Medicine'),
            ),
          ],
        ),
        ...reminders.map(
          (item) => compact
              ? LifeOsCard(
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(item.icon, color: item.color, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: lifeOsMuted),
                            ),
                          ],
                        ),
                      ),
                      if (item.pill != null)
                        _Pill(
                          label: item.pill!,
                          color: const Color(0xFF18A058),
                        ),
                    ],
                  ),
                )
              : LifeOsListTile(
                  title: item.title,
                  subtitle: item.subtitle,
                  icon: item.icon,
                  color: item.color,
                  trailing: item.pill == null
                      ? null
                      : _Pill(
                          label: item.pill!,
                          color: const Color(0xFF18A058),
                        ),
                ),
        ),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LifeOsPage(
      title: 'Settings',
      children: [
        const LifeOsListTile(
          title: 'Arjun Sharma',
          subtitle: 'arjun@gmail.com',
          icon: Icons.person_rounded,
          color: Color(0xFFB08A63),
        ),
        const LifeOsListTile(
          title: 'Account',
          subtitle: 'Profile, password, and devices',
          icon: Icons.person_outline_rounded,
          trailing: Icon(Icons.chevron_right_rounded),
        ),
        const LifeOsListTile(
          title: 'Security & Privacy',
          subtitle: 'Biometrics, vault, permissions',
          icon: Icons.security_rounded,
          trailing: Icon(Icons.chevron_right_rounded),
        ),
        const LifeOsListTile(
          title: 'AI Preferences',
          subtitle: 'Memory, tone, suggestions',
          icon: Icons.auto_awesome_rounded,
          trailing: Icon(Icons.chevron_right_rounded),
        ),
        const LifeOsListTile(
          title: 'Notifications',
          subtitle: 'Reminders and digest alerts',
          icon: Icons.notifications_none_rounded,
          trailing: Icon(Icons.chevron_right_rounded),
        ),
        const LifeOsListTile(
          title: 'Backup & Sync',
          subtitle: 'Cloud sync and exports',
          icon: Icons.cloud_sync_rounded,
          trailing: Icon(Icons.chevron_right_rounded),
        ),
        const LifeOsListTile(
          title: 'Theme',
          subtitle: 'System',
          icon: Icons.dark_mode_outlined,
          trailing: Icon(Icons.chevron_right_rounded),
        ),
        TextButton.icon(
          onPressed: () => context.go('/login'),
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Logout'),
        ),
      ],
    );
  }
}

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    return LifeOsPage(
      title: 'LifeOS AI',
      subtitle: 'Your Life. Organized. Enhanced by AI.',
      children: [
        Center(child: LifeOsGradientIcon(size: compact ? 72 : 82)),
        const LifeOsListTile(
          title: 'AI Powered Search',
          subtitle: 'Find anything across your life instantly',
          icon: Icons.search_rounded,
        ),
        const LifeOsListTile(
          title: 'Offline Access',
          subtitle: 'Keep key data available anywhere',
          icon: Icons.offline_bolt_rounded,
        ),
        const LifeOsListTile(
          title: 'Secure & Private',
          subtitle: 'Local vault patterns for sensitive records',
          icon: Icons.shield_rounded,
        ),
        const LifeOsListTile(
          title: 'All Your Data in One Place',
          subtitle: 'Notes, expenses, documents, health, and more',
          icon: Icons.all_inbox_rounded,
        ),
        FilledButton(onPressed: () {}, child: const Text('Upgrade to Premium')),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _PasswordItem {
  const _PasswordItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class _FileItem {
  const _FileItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class _TaskItem {
  const _TaskItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class _ContactItem {
  const _ContactItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class _ReminderItem {
  const _ReminderItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.pill,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? pill;
}
