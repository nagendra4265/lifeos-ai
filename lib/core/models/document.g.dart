// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocumentAdapter extends TypeAdapter<Document> {
  @override
  final int typeId = 5;

  @override
  Document read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Document(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      issuer: fields[3] as String,
      issuedDate: fields[4] as String,
      expiryDate: fields[5] as String,
      holderName: fields[6] as String,
      documentNumber: fields[7] as String,
      summary: fields[8] as String,
      previewNote: fields[9] as String,
      ocrExtractedText: fields[10] as String,
      iconCodePoint: fields[11] as int,
      metadata: (fields[12] as Map).cast<String, String>(),
      isPinned: fields[13] as bool,
      reminderSet: fields[14] as bool,
      isFavorite: fields[15] as bool,
      isArchived: fields[16] as bool,
      tags: (fields[17] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Document obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.issuer)
      ..writeByte(4)
      ..write(obj.issuedDate)
      ..writeByte(5)
      ..write(obj.expiryDate)
      ..writeByte(6)
      ..write(obj.holderName)
      ..writeByte(7)
      ..write(obj.documentNumber)
      ..writeByte(8)
      ..write(obj.summary)
      ..writeByte(9)
      ..write(obj.previewNote)
      ..writeByte(10)
      ..write(obj.ocrExtractedText)
      ..writeByte(11)
      ..write(obj.iconCodePoint)
      ..writeByte(12)
      ..write(obj.metadata)
      ..writeByte(13)
      ..write(obj.isPinned)
      ..writeByte(14)
      ..write(obj.reminderSet)
      ..writeByte(15)
      ..write(obj.isFavorite)
      ..writeByte(16)
      ..write(obj.isArchived)
      ..writeByte(17)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DocumentImpl _$$DocumentImplFromJson(Map<String, dynamic> json) =>
    _$DocumentImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      issuer: json['issuer'] as String? ?? '',
      issuedDate: json['issuedDate'] as String? ?? '',
      expiryDate: json['expiryDate'] as String? ?? '',
      holderName: json['holderName'] as String? ?? '',
      documentNumber: json['documentNumber'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      previewNote: json['previewNote'] as String? ?? '',
      ocrExtractedText: json['ocrExtractedText'] as String? ?? '',
      iconCodePoint: (json['iconCodePoint'] as num?)?.toInt() ?? 0,
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      isPinned: json['isPinned'] as bool? ?? false,
      reminderSet: json['reminderSet'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$DocumentImplToJson(_$DocumentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'issuer': instance.issuer,
      'issuedDate': instance.issuedDate,
      'expiryDate': instance.expiryDate,
      'holderName': instance.holderName,
      'documentNumber': instance.documentNumber,
      'summary': instance.summary,
      'previewNote': instance.previewNote,
      'ocrExtractedText': instance.ocrExtractedText,
      'iconCodePoint': instance.iconCodePoint,
      'metadata': instance.metadata,
      'isPinned': instance.isPinned,
      'reminderSet': instance.reminderSet,
      'isFavorite': instance.isFavorite,
      'isArchived': instance.isArchived,
      'tags': instance.tags,
    };
