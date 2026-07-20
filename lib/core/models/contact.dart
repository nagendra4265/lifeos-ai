import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

@freezed
@HiveType(typeId: 4)
class Contact with _$Contact {
  const factory Contact({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) String? phone,
    @HiveField(3) String? email,
    @HiveField(4) String? avatarUrl,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);
}
