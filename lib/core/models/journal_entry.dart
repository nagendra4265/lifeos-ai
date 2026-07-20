import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'journal_entry.freezed.dart';
part 'journal_entry.g.dart';

@freezed
@HiveType(typeId: 8)
class JournalEntry with _$JournalEntry {
  const factory JournalEntry({
    @HiveField(0) required String id,
    @HiveField(1) required String content,
    @HiveField(2) required DateTime date,
    @HiveField(3) List<String>? attachments,
    @HiveField(4) String? mood,
  }) = _JournalEntry;

  factory JournalEntry.fromJson(Map<String, dynamic> json) => _$JournalEntryFromJson(json);
}
