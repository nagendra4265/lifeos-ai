import 'package:flutter_application_1/core/models/document.dart';
import 'package:flutter_application_1/core/repositories/base_repository.dart';

class DocumentsRepository extends BaseRepository<Document> {
  DocumentsRepository() : super('documents');
}
