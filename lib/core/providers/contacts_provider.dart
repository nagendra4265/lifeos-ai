import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/contact.dart';
import 'package:flutter_application_1/core/repositories/contacts_repository.dart';
import 'package:uuid/uuid.dart';

final contactsRepositoryProvider = Provider((ref) => ContactsRepository());

final contactsProvider = AsyncNotifierProvider<ContactsNotifier, List<Contact>>(ContactsNotifier.new);

class ContactsNotifier extends AsyncNotifier<List<Contact>> {
  late final ContactsRepository _repository;

  @override
  Future<List<Contact>> build() async {
    _repository = ref.watch(contactsRepositoryProvider);
    return _repository.getAll();
  }

  Future<void> addContact({required String name, String? phone, String? email}) async {
    final contact = Contact(
      id: const Uuid().v4(),
      name: name,
      phone: phone,
      email: email,
    );
    state = await AsyncValue.guard(() async {
      await _repository.save(contact.id, contact);
      return _repository.getAll();
    });
  }

  Future<void> deleteContact(String id) async {
    state = await AsyncValue.guard(() async {
      await _repository.delete(id);
      return _repository.getAll();
    });
  }
}
