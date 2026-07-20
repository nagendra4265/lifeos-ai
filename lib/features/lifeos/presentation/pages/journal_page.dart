import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/core/providers/journal_provider.dart';
import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class JournalPage extends ConsumerStatefulWidget {
  const JournalPage({super.key});

  @override
  ConsumerState<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends ConsumerState<JournalPage> {
  late final TextEditingController _journalController;
  final List<String> _attachments = [];

  String _selectedMood = 'Happy';
  final List<Map<String, dynamic>> _moods = [
    {'label': 'Happy', 'icon': Icons.sentiment_very_satisfied_rounded, 'color': Colors.orange},
    {'label': 'Calm', 'icon': Icons.sentiment_satisfied_rounded, 'color': Colors.green},
    {'label': 'Focused', 'icon': Icons.center_focus_strong_rounded, 'color': Colors.blue},
    {'label': 'Tired', 'icon': Icons.sentiment_dissatisfied_rounded, 'color': Colors.purple},
    {'label': 'Stressed', 'icon': Icons.sentiment_very_dissatisfied_rounded, 'color': Colors.red},
  ];

  @override
  void initState() {
    super.initState();
    _journalController = TextEditingController();
  }

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  Future<void> _attachItem(String type) async {
    setState(() => _attachments.add(type));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$type attached to journal entry.')),
    );
  }

  Future<void> _saveEntry() async {
    final content = _journalController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write something before saving.')),
      );
      return;
    }
    
    await ref.read(journalProvider.notifier).addEntry(
      content: content,
      attachments: List.from(_attachments),
    );
    
    _journalController.clear();
    setState(() => _attachments.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Journal entry saved.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    final entriesAsync = ref.watch(journalProvider);

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
                DateFormat('MMMM dd, yyyy').format(DateTime.now()),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: lifeOsMuted),
              ),
              const SizedBox(height: 14),
              Text(
                'How are you feeling?',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: lifeOsMuted, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _moods.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final mood = _moods[index];
                    final isSelected = _selectedMood == mood['label'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMood = mood['label'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? (mood['color'] as Color).withValues(alpha: .15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? (mood['color'] as Color) : lifeOsBorder,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              mood['icon'] as IconData,
                              size: 20,
                              color: isSelected ? (mood['color'] as Color) : lifeOsMuted,
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 6),
                              Text(
                                mood['label'] as String,
                                style: TextStyle(
                                  color: mood['color'] as Color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_attachments.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _attachments
                      .map(
                        (item) => Chip(
                          label: Text(item),
                          avatar: const Icon(
                            Icons.attachment_rounded,
                            size: 16,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 16),
              TextField(
                controller: _journalController,
                minLines: compact ? 3 : 4,
                maxLines: compact ? 4 : 6,
                decoration: InputDecoration(
                  hintText: 'Write your thoughts here...',
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
                    onPressed: () => _attachItem('Voice note'),
                    icon: const Icon(Icons.mic_none_rounded),
                  ),
                  IconButton(
                    onPressed: () => _attachItem('Image'),
                    icon: const Icon(Icons.image_outlined),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _saveEntry,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
        entriesAsync.when(
          data: (entries) {
            if (entries.isEmpty) return const SizedBox.shrink();
            final sorted = entries.toList()..sort((a, b) => b.date.compareTo(a.date));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LifeOsSectionTitle(title: 'Recent Entries'),
                const SizedBox(height: 10),
                ...sorted.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: LifeOsCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(DateFormat('MMM dd, hh:mm a').format(e.date), style: Theme.of(context).textTheme.bodySmall),
                            IconButton(
                              onPressed: () => ref.read(journalProvider.notifier).deleteEntry(e.id),
                              icon: const Icon(Icons.delete_outline_rounded, size: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(e.content),
                        if (e.attachments?.isNotEmpty == true) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 4,
                            children: e.attachments!.map((a) => Icon(Icons.attachment_rounded, size: 14, color: lifeOsMuted)).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                )),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, st) => Text('Error loading journal: $err'),
        ),
      ],
    );
  }
}
