import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/document.dart';
import 'package:flutter_application_1/core/repositories/documents_repository.dart';
import 'package:uuid/uuid.dart';

final documentsRepositoryProvider = Provider((ref) => DocumentsRepository());

final documentsProvider = AsyncNotifierProvider<DocumentsNotifier, List<Document>>(DocumentsNotifier.new);

class DocumentsNotifier extends AsyncNotifier<List<Document>> {
  late final DocumentsRepository _repository;

  @override
  Future<List<Document>> build() async {
    _repository = ref.watch(documentsRepositoryProvider);
    return _repository.getAll();
  }

  Future<void> addDocument({
    required String title,
    required String category,
    String? issuer,
    String? expiryDate,
  }) async {
    final document = Document(
      id: const Uuid().v4(),
      title: title,
      category: category,
      issuer: issuer ?? '',
      expiryDate: expiryDate ?? '',
    );
    state = await AsyncValue.guard(() async {
      await _repository.save(document.id, document);
      return _repository.getAll();
    });
  }

  Future<void> updateDocument(Document document) async {
    state = await AsyncValue.guard(() async {
      await _repository.save(document.id, document);
      return _repository.getAll();
    });
  }

  Future<void> deleteDocument(String id) async {
    state = await AsyncValue.guard(() async {
      await _repository.delete(id);
      return _repository.getAll();
    });
  }
}
