import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});

class UserProfile {
  final String name;
  final String email;
  final String plan;

  UserProfile({required this.name, required this.email, required this.plan});
}

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(UserProfile(name: 'Arjun Sharma', email: 'arjun@gmail.com', plan: 'Premium Plan')) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox('settings');
    final name = box.get('user_name', defaultValue: 'Arjun Sharma');
    final email = box.get('user_email', defaultValue: 'arjun@gmail.com');
    state = UserProfile(name: name, email: email, plan: 'Premium Plan');
  }

  Future<void> updateProfile({required String name, required String email}) async {
    final box = await Hive.openBox('settings');
    await box.put('user_name', name);
    await box.put('user_email', email);
    state = UserProfile(name: name, email: email, plan: 'Premium Plan');
  }
}
