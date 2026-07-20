import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'password_entry.freezed.dart';
part 'password_entry.g.dart';

@freezed
@HiveType(typeId: 7)
class PasswordEntry with _$PasswordEntry {
  const factory PasswordEntry({
    @HiveField(0) required String id,
    @HiveField(1) required String site,
    @HiveField(2) required String username,
    @HiveField(3) String? password,
    @HiveField(4) @Default('Others') String category,
  }) = _PasswordEntry;

  factory PasswordEntry.fromJson(Map<String, dynamic> json) => _$PasswordEntryFromJson(json);
}
