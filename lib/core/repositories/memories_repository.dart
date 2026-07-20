import 'package:flutter_application_1/core/models/memory.dart';
import 'package:flutter_application_1/core/repositories/base_repository.dart';

class MemoriesRepository extends BaseRepository<Memory> {
  MemoriesRepository() : super('memories');
}
