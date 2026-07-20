import 'package:flutter_application_1/core/models/contact.dart';
import 'package:flutter_application_1/core/repositories/base_repository.dart';

class ContactsRepository extends BaseRepository<Contact> {
  ContactsRepository() : super('contacts');
}
