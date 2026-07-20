import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'reminder.freezed.dart';
part 'reminder.g.dart';

@freezed
@HiveType(typeId: 3)
class Reminder with _$Reminder {
  const factory Reminder({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required DateTime dateTime,
    @HiveField(3) String? category,
    @HiveField(4) @Default(false) bool isEnabled,
    @HiveField(5) String? recurrence,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) => _$ReminderFromJson(json);
}
