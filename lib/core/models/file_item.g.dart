// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FileItemAdapter extends TypeAdapter<FileItem> {
  @override
  final int typeId = 10;

  @override
  FileItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FileItem(
      id: fields[0] as String,
      name: fields[1] as String,
      size: fields[2] as String,
      type: fields[3] as String,
      date: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FileItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.size)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileItemImpl _$$FileItemImplFromJson(Map<String, dynamic> json) =>
    _$FileItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      size: json['size'] as String,
      type: json['type'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$FileItemImplToJson(_$FileItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'size': instance.size,
      'type': instance.type,
      'date': instance.date.toIso8601String(),
    };
