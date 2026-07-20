import 'package:flutter_application_1/core/models/health_metric.dart';
import 'package:flutter_application_1/core/repositories/base_repository.dart';

class HealthRepository extends BaseRepository<HealthMetric> {
  HealthRepository() : super('health');
}
