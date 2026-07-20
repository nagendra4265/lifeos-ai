import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/providers/contacts_provider.dart';
import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class ContactsPage extends ConsumerStatefulWidget {
  const ContactsPage({super.key});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage> {
  String _query = '';

  Future<void> _showContactsMenu() async {
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
                  'Contacts actions',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Manage your people list.',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.person_add_alt_1_rounded),
                  title: const Text('Add contact'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _addContact();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.search_rounded),
                  title: const Text('Clear search'),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() => _query = '');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addContact() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
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
    final name = nameController.text.trim();
    if (name.isEmpty) return;
    
    ref.read(contactsProvider.notifier).addContact(
      name: name,
      phone: phoneController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contactsAsync = ref.watch(contactsProvider);

    return contactsAsync.when(
      data: (contacts) {
        final visibleContacts = contacts.where((contact) =>
            _query.isEmpty ||
            contact.name.toLowerCase().contains(_query) ||
            (contact.phone?.toLowerCase().contains(_query) ?? false)
        ).toList();

        return LifeOsPage(
          title: 'Contacts',
          trailing: IconButton(
            onPressed: _showContactsMenu,
            icon: const Icon(Icons.more_vert_rounded),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _addContact,
            child: const Icon(Icons.add),
          ),
          children: [
            LifeOsSearchField(
              hintText: 'Search contacts...',
              onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
            ),
            if (visibleContacts.isEmpty)
              const LifeOsCard(child: Center(child: Text('No contacts found.')))
            else
              ...visibleContacts.map(
                (contact) => LifeOsListTile(
                  title: contact.name,
                  subtitle: contact.phone ?? 'No phone',
                  icon: Icons.person_rounded,
                  color: Colors.blueAccent,
                  trailing: IconButton(
                    onPressed: () => ref.read(contactsProvider.notifier).deleteContact(contact.id),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err')),
    );
  }
}
