import 'package:flutter_application_1/core/models/task.dart';
import 'package:flutter_application_1/core/repositories/base_repository.dart';

class TasksRepository extends BaseRepository<Task> {
  TasksRepository() : super('tasks');
}
