import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/memory.dart';
import 'package:flutter_application_1/core/repositories/memories_repository.dart';
import 'package:uuid/uuid.dart';

final memoriesRepositoryProvider = Provider((ref) => MemoriesRepository());

final memoriesProvider = AsyncNotifierProvider<MemoriesNotifier, List<Memory>>(MemoriesNotifier.new);

class MemoriesNotifier extends AsyncNotifier<List<Memory>> {
  late final MemoriesRepository _repository;

  @override
  Future<List<Memory>> build() async {
    _repository = ref.watch(memoriesRepositoryProvider);
    return _repository.getAll();
  }

  Future<void> addMemory({required String title, String? category}) async {
    final memory = Memory(
      id: const Uuid().v4(),
      title: title,
      date: DateTime.now(),
      category: category,
    );
    state = await AsyncValue.guard(() async {
      await _repository.save(memory.id, memory);
      return _repository.getAll();
    });
  }

  Future<void> deleteMemory(String id) async {
    state = await AsyncValue.guard(() async {
      await _repository.delete(id);
      return _repository.getAll();
    });
  }
}
