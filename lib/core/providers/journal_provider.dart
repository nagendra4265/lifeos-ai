import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/journal_entry.dart';
import 'package:flutter_application_1/core/repositories/journal_repository.dart';
import 'package:uuid/uuid.dart';

final journalRepositoryProvider = Provider((ref) => JournalRepository());

final journalProvider = AsyncNotifierProvider<JournalNotifier, List<JournalEntry>>(JournalNotifier.new);

class JournalNotifier extends AsyncNotifier<List<JournalEntry>> {
  late final JournalRepository _repository;

  @override
  Future<List<JournalEntry>> build() async {
    _repository = ref.watch(journalRepositoryProvider);
    return _repository.getAll();
  }

  Future<void> addEntry({required String content, String? mood, List<String>? attachments}) async {
    final entry = JournalEntry(
      id: const Uuid().v4(),
      content: content,
      date: DateTime.now(),
      mood: mood,
      attachments: attachments,
    );
    state = await AsyncValue.guard(() async {
      await _repository.save(entry.id, entry);
      return _repository.getAll();
    });
  }

  Future<void> deleteEntry(String id) async {
    state = await AsyncValue.guard(() async {
      await _repository.delete(id);
      return _repository.getAll();
    });
  }
}
