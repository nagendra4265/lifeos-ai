// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_metric.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthMetricAdapter extends TypeAdapter<HealthMetric> {
  @override
  final int typeId = 6;

  @override
  HealthMetric read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthMetric(
      id: fields[0] as String,
      type: fields[1] as String,
      value: fields[2] as String,
      timestamp: fields[3] as DateTime,
      status: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HealthMetric obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.value)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthMetricAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthMetricImpl _$$HealthMetricImplFromJson(Map<String, dynamic> json) =>
    _$HealthMetricImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      value: json['value'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$HealthMetricImplToJson(_$HealthMetricImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'value': instance.value,
      'timestamp': instance.timestamp.toIso8601String(),
      'status': instance.status,
    };
