import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'file_item.freezed.dart';
part 'file_item.g.dart';

@freezed
@HiveType(typeId: 10)
class FileItem with _$FileItem {
  const factory FileItem({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String size,
    @HiveField(3) required String type,
    @HiveField(4) required DateTime date,
  }) = _FileItem;

  factory FileItem.fromJson(Map<String, dynamic> json) => _$FileItemFromJson(json);
}
