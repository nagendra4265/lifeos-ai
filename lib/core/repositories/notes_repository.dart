import 'package:flutter_application_1/core/models/note.dart';
import 'package:flutter_application_1/core/repositories/base_repository.dart';

class NotesRepository extends BaseRepository<Note> {
  NotesRepository() : super('notes');
}
