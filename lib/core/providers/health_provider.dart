import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/health_metric.dart';
import 'package:flutter_application_1/core/repositories/health_repository.dart';
import 'package:uuid/uuid.dart';

final healthRepositoryProvider = Provider((ref) => HealthRepository());

final healthProvider = AsyncNotifierProvider<HealthNotifier, List<HealthMetric>>(HealthNotifier.new);

class HealthNotifier extends AsyncNotifier<List<HealthMetric>> {
  late final HealthRepository _repository;

  @override
  Future<List<HealthMetric>> build() async {
    _repository = ref.watch(healthRepositoryProvider);
    return _repository.getAll();
  }

  Future<void> addReading({required String type, required String value, String? status}) async {
    final metric = HealthMetric(
      id: const Uuid().v4(),
      type: type,
      value: value,
      timestamp: DateTime.now(),
      status: status,
    );
    state = await AsyncValue.guard(() async {
      await _repository.save(metric.id, metric);
      return _repository.getAll();
    });
  }
}
