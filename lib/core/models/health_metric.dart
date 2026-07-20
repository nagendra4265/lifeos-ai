import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'health_metric.freezed.dart';
part 'health_metric.g.dart';

@freezed
@HiveType(typeId: 6)
class HealthMetric with _$HealthMetric {
  const factory HealthMetric({
    @HiveField(0) required String id,
    @HiveField(1) required String type,
    @HiveField(2) required String value,
    @HiveField(3) required DateTime timestamp,
    @HiveField(4) String? status,
  }) = _HealthMetric;

  factory HealthMetric.fromJson(Map<String, dynamic> json) => _$HealthMetricFromJson(json);
}
