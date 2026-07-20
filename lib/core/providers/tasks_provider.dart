import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/task.dart';
import 'package:flutter_application_1/core/repositories/tasks_repository.dart';
import 'package:uuid/uuid.dart';

final tasksRepositoryProvider = Provider((ref) => TasksRepository());

final tasksProvider = AsyncNotifierProvider<TasksNotifier, List<Task>>(TasksNotifier.new);

class TasksNotifier extends AsyncNotifier<List<Task>> {
  late final TasksRepository _repository;

  @override
  Future<List<Task>> build() async {
    _repository = ref.watch(tasksRepositoryProvider);
    return _repository.getAll();
  }

  Future<void> addTask({required String title, String? subtitle, DateTime? dueDate}) async {
    final task = Task(
      id: const Uuid().v4(),
      title: title,
      subtitle: subtitle,
      dueDate: dueDate,
    );
    state = await AsyncValue.guard(() async {
      await _repository.save(task.id, task);
      return _repository.getAll();
    });
  }

  Future<void> toggleTask(Task task) async {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    state = await AsyncValue.guard(() async {
      await _repository.save(updated.id, updated);
      return _repository.getAll();
    });
  }

  Future<void> deleteTask(String id) async {
    state = await AsyncValue.guard(() async {
      await _repository.delete(id);
      return _repository.getAll();
    });
  }
}
