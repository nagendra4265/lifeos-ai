import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'memory.freezed.dart';
part 'memory.g.dart';

@freezed
@HiveType(typeId: 9)
class Memory with _$Memory {
  const factory Memory({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required DateTime date,
    @HiveField(3) List<String>? images,
    @HiveField(4) String? category,
  }) = _Memory;

  factory Memory.fromJson(Map<String, dynamic> json) => _$MemoryFromJson(json);
}
