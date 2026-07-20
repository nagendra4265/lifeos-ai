import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/reminder.dart';
import 'package:flutter_application_1/core/repositories/reminders_repository.dart';
import 'package:uuid/uuid.dart';

final remindersRepositoryProvider = Provider((ref) => RemindersRepository());

final remindersProvider = AsyncNotifierProvider<RemindersNotifier, List<Reminder>>(RemindersNotifier.new);

class RemindersNotifier extends AsyncNotifier<List<Reminder>> {
  late final RemindersRepository _repository;

  @override
  Future<List<Reminder>> build() async {
    _repository = ref.watch(remindersRepositoryProvider);
    return _repository.getAll();
  }

  Future<void> addReminder({required String title, required DateTime dateTime, String? category}) async {
    final reminder = Reminder(
      id: const Uuid().v4(),
      title: title,
      dateTime: dateTime,
      category: category,
      isEnabled: true,
    );
    state = await AsyncValue.guard(() async {
      await _repository.save(reminder.id, reminder);
      return _repository.getAll();
    });
  }

  Future<void> deleteReminder(String id) async {
    state = await AsyncValue.guard(() async {
      await _repository.delete(id);
      return _repository.getAll();
    });
  }
}
