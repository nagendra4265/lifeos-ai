import 'package:flutter_application_1/core/models/journal_entry.dart';
import 'package:flutter_application_1/core/repositories/base_repository.dart';

class JournalRepository extends BaseRepository<JournalEntry> {
  JournalRepository() : super('journal');
}
