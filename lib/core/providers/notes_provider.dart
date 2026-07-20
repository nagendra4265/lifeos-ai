import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/note.dart';
import 'package:flutter_application_1/core/repositories/notes_repository.dart';
import 'package:uuid/uuid.dart';

final notesRepositoryProvider = Provider((ref) => NotesRepository());

final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);

class NotesNotifier extends AsyncNotifier<List<Note>> {
  late final NotesRepository _repository;

  @override
  Future<List<Note>> build() async {
    _repository = ref.watch(notesRepositoryProvider);
    return _repository.getAll();
  }

  Future<void> addNote({required String title, required String content}) async {
    final note = Note(
      id: const Uuid().v4(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.save(note.id, note);
      return _repository.getAll();
    });
  }

  Future<void> updateNote(Note note) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updated = note.copyWith(updatedAt: DateTime.now());
      await _repository.save(updated.id, updated);
      return _repository.getAll();
    });
  }

  Future<void> deleteNote(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.delete(id);
      return _repository.getAll();
    });
  }
}
