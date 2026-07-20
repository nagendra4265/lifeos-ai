import 'package:flutter_application_1/core/models/file_item.dart';
import 'package:flutter_application_1/core/repositories/base_repository.dart';

class FilesRepository extends BaseRepository<FileItem> {
  FilesRepository() : super('files');
}
