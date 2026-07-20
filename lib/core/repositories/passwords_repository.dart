import 'package:flutter_application_1/core/models/password_entry.dart';
import 'package:flutter_application_1/core/repositories/base_repository.dart';

class PasswordsRepository extends BaseRepository<PasswordEntry> {
  PasswordsRepository() : super('passwords');
}
