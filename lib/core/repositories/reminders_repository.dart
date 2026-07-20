import 'package:flutter_application_1/core/models/reminder.dart';
import 'package:flutter_application_1/core/repositories/base_repository.dart';

class RemindersRepository extends BaseRepository<Reminder> {
  RemindersRepository() : super('reminders');
}
