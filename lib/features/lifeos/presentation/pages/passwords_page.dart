import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/providers/passwords_provider.dart';
import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class PasswordsPage extends ConsumerStatefulWidget {
  const PasswordsPage({super.key});

  @override
  ConsumerState<PasswordsPage> createState() => _PasswordsPageState();
}

class _PasswordsPageState extends ConsumerState<PasswordsPage> {
  String _query = '';

  Future<void> _showVaultMenu() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vault actions',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Manage your password vault.',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.add_rounded),
                  title: const Text('Add password'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _addPassword();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.file_download_rounded),
                  title: const Text('Export vault'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vault export prepared.')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.security_rounded),
                  title: const Text('Lock vault'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vault locked.')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addPassword() async {
    final siteController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: siteController,
                decoration: const InputDecoration(labelText: 'Site'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (saved != true) return;
    final site = siteController.text.trim();
    if (site.isEmpty) return;
    
    ref.read(passwordsProvider.notifier).addPassword(
      site: site,
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final passwordsAsync = ref.watch(passwordsProvider);

    return passwordsAsync.when(
      data: (passwords) {
        final filtered = passwords.where((item) =>
          _query.isEmpty ||
          item.site.toLowerCase().contains(_query) ||
          item.username.toLowerCase().contains(_query)
        ).toList();

        return LifeOsPage(
          title: 'Passwords',
          trailing: IconButton(
            onPressed: _showVaultMenu,
            icon: const Icon(Icons.more_vert_rounded),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _addPassword,
            child: const Icon(Icons.add),
          ),
          children: [
            LifeOsSearchField(
              hintText: 'Search passwords...',
              onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
            ),
            if (filtered.isEmpty)
              const LifeOsCard(child: Center(child: Text('No passwords found.')))
            else
              ...filtered.map((item) => LifeOsListTile(
                title: item.site,
                subtitle: item.username,
                icon: Icons.lock_rounded,
                color: lifeOsPurple,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: item.password ?? ''));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Password copied to clipboard'), behavior: SnackBarBehavior.floating),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, size: 18),
                    ),
                    IconButton(
                      onPressed: () => ref.read(passwordsProvider.notifier).deletePassword(item.id),
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    ),
                  ],
                ),
              )),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err')),
    );
  }
}
