// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PasswordEntryAdapter extends TypeAdapter<PasswordEntry> {
  @override
  final int typeId = 7;

  @override
  PasswordEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PasswordEntry(
      id: fields[0] as String,
      site: fields[1] as String,
      username: fields[2] as String,
      password: fields[3] as String?,
      category: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PasswordEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.site)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PasswordEntryImpl _$$PasswordEntryImplFromJson(Map<String, dynamic> json) =>
    _$PasswordEntryImpl(
      id: json['id'] as String,
      site: json['site'] as String,
      username: json['username'] as String,
      password: json['password'] as String?,
      category: json['category'] as String? ?? 'Others',
    );

Map<String, dynamic> _$$PasswordEntryImplToJson(_$PasswordEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'site': instance.site,
      'username': instance.username,
      'password': instance.password,
      'category': instance.category,
    };
