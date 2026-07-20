import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/password_entry.dart';
import 'package:flutter_application_1/core/repositories/passwords_repository.dart';
import 'package:uuid/uuid.dart';

final passwordsRepositoryProvider = Provider((ref) => PasswordsRepository());

final passwordsProvider = AsyncNotifierProvider<PasswordsNotifier, List<PasswordEntry>>(PasswordsNotifier.new);

class PasswordsNotifier extends AsyncNotifier<List<PasswordEntry>> {
  late final PasswordsRepository _repository;

  @override
  Future<List<PasswordEntry>> build() async {
    _repository = ref.watch(passwordsRepositoryProvider);
    return _repository.getAll();
  }

  Future<void> addPassword({required String site, required String username, String? password}) async {
    final entry = PasswordEntry(
      id: const Uuid().v4(),
      site: site,
      username: username,
      password: password,
    );
    state = await AsyncValue.guard(() async {
      await _repository.save(entry.id, entry);
      return _repository.getAll();
    });
  }

  Future<void> deletePassword(String id) async {
    state = await AsyncValue.guard(() async {
      await _repository.delete(id);
      return _repository.getAll();
    });
  }
}
