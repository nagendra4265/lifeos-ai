import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/providers/user_profile_provider.dart';
import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _openSetting(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title will be connected in the next release.')),
    );
  }

  Future<void> _editProfile(BuildContext context, WidgetRef ref, UserProfile profile) async {
    final nameController = TextEditingController(text: profile.name);
    final emailController = TextEditingController(text: profile.email);
    
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 8),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    );

    if (saved == true) {
      await ref.read(userProfileProvider.notifier).updateProfile(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return LifeOsPage(
      title: 'Settings',
      children: [
        LifeOsListTile(
          title: profile.name,
          subtitle: profile.email,
          icon: Icons.person_rounded,
          color: const Color(0xFFB08A63),
          trailing: IconButton(
            onPressed: () => _editProfile(context, ref, profile),
            icon: const Icon(Icons.edit_rounded, size: 18),
          ),
        ),
        LifeOsListTile(
          title: 'Account',
          subtitle: 'Profile, password, and devices',
          icon: Icons.person_outline_rounded,
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _editProfile(context, ref, profile),
        ),
        LifeOsListTile(
          title: 'Security & Privacy',
          subtitle: 'Biometrics, vault, permissions',
          icon: Icons.security_rounded,
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _openSetting(context, 'Security & Privacy'),
        ),
        LifeOsListTile(
          title: 'AI Preferences',
          subtitle: 'Memory, tone, suggestions',
          icon: Icons.auto_awesome_rounded,
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _openSetting(context, 'AI Preferences'),
        ),
        LifeOsListTile(
          title: 'Notifications',
          subtitle: 'Reminders and digest alerts',
          icon: Icons.notifications_none_rounded,
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _openSetting(context, 'Notifications'),
        ),
        LifeOsListTile(
          title: 'Backup & Sync',
          subtitle: 'Cloud sync and exports',
          icon: Icons.cloud_sync_rounded,
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _openSetting(context, 'Backup & Sync'),
        ),
        LifeOsListTile(
          title: 'Theme',
          subtitle: 'System',
          icon: Icons.dark_mode_outlined,
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _openSetting(context, 'Theme'),
        ),
        TextButton.icon(
          onPressed: () => context.go('/login'),
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Logout'),
        ),
      ],
    );
  }
}
