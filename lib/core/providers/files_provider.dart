import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/file_item.dart';
import 'package:flutter_application_1/core/repositories/files_repository.dart';
import 'package:uuid/uuid.dart';

final filesRepositoryProvider = Provider((ref) => FilesRepository());

final filesProvider = AsyncNotifierProvider<FilesNotifier, List<FileItem>>(FilesNotifier.new);

class FilesNotifier extends AsyncNotifier<List<FileItem>> {
  late final FilesRepository _repository;

  @override
  Future<List<FileItem>> build() async {
    _repository = ref.watch(filesRepositoryProvider);
    return _repository.getAll();
  }

  Future<void> addFile({required String name, required String size, required String type}) async {
    final item = FileItem(
      id: const Uuid().v4(),
      name: name,
      size: size,
      type: type,
      date: DateTime.now(),
    );
    state = await AsyncValue.guard(() async {
      await _repository.save(item.id, item);
      return _repository.getAll();
    });
  }

  Future<void> deleteFile(String id) async {
    state = await AsyncValue.guard(() async {
      await _repository.delete(id);
      return _repository.getAll();
    });
  }
}
