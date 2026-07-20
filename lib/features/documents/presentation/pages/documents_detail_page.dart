import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_application_1/features/documents/data/documents_notifier.dart';
import 'package:flutter_application_1/core/models/document.dart';

class DocumentsDetailPage extends ConsumerStatefulWidget {
  const DocumentsDetailPage({required this.documentId, super.key});

  final String documentId;

  @override
  ConsumerState<DocumentsDetailPage> createState() =>
      _DocumentsDetailPageState();
}

class _DocumentsDetailPageState extends ConsumerState<DocumentsDetailPage> {
  bool _showOcrAnalysis = false;
  bool _isAnalyzing = false;

  void _startOcrAnalysis() {
    setState(() {
      _isAnalyzing = true;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _showOcrAnalysis = true;
      });
    });
  }

  String _statusLabel(Document document) {
    if (document.expiryDate == 'N/A') return 'Unknown';
    final days = document.daysUntilExpiry;
    if (days < 0) return 'Expired';
    if (days == 0) return 'Expires today';
    if (days < 30) return 'Expiring soon';
    return 'Active';
  }

  Color _statusColor(Document document) {
    if (document.expiryDate == 'N/A') return Colors.grey;
    final days = document.daysUntilExpiry;
    if (days < 0) return Colors.redAccent;
    if (days < 30) return Colors.orangeAccent;
    return Colors.greenAccent.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final document = ref
        .watch(documentsNotifierProvider)
        .firstWhere(
          (item) => item.id == widget.documentId,
          orElse: () => DocumentsNotifier.unknownDocument,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document details'),
        actions: [
          IconButton(
            key: const Key('pinDocumentButton'),
            icon: Icon(
              document.isPinned
                  ? Icons.push_pin_rounded
                  : Icons.push_pin_outlined,
            ),
            onPressed: () => _togglePinDocument(context, document),
          ),
          IconButton(
            key: const Key('remindDocumentButton'),
            icon: Icon(
              document.reminderSet
                  ? Icons.alarm_on_rounded
                  : Icons.alarm_outlined,
            ),
            onPressed: () => _setExpiryReminder(context, document),
          ),
          IconButton(
            key: const Key('exportDocumentButton'),
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () => _exportDocument(context, document),
          ),
          IconButton(
            key: const Key('favoriteDocumentButton'),
            icon: Icon(
              document.isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded,
            ),
            onPressed: () => _toggleFavoriteDocument(context, document),
          ),
          IconButton(
            key: const Key('archiveDocumentButton'),
            icon: Icon(
              document.isArchived
                  ? Icons.unarchive_outlined
                  : Icons.archive_outlined,
            ),
            onPressed: () => _toggleArchiveDocument(context, document),
          ),
          IconButton(
            key: const Key('duplicateDocumentButton'),
            icon: const Icon(Icons.copy_all_outlined),
            onPressed: () => _duplicateDocument(context, document),
          ),
          IconButton(
            key: const Key('shareDocumentButton'),
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _shareDocument(context, document),
          ),
          IconButton(
            key: const Key('editDocumentButton'),
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditDialog(context, document),
          ),
          IconButton(
            key: const Key('deleteDocumentButton'),
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, document),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              document.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(_statusLabel(document)),
              backgroundColor: _statusColor(document),
            ),
            const SizedBox(height: 24),
            Text(
              'OCR metadata',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow(
                      context,
                      Icons.badge_outlined,
                      'Document number',
                      document.documentNumber,
                    ),
                    const SizedBox(height: 14),
                    _buildRow(
                      context,
                      Icons.person_outline,
                      'Name',
                      document.holderName,
                    ),
                    const SizedBox(height: 14),
                    _buildRow(
                      context,
                      Icons.calendar_today_outlined,
                      'Issued',
                      document.issuedDate,
                    ),
                    const SizedBox(height: 14),
                    _buildRow(
                      context,
                      Icons.calendar_month_outlined,
                      'Expiry',
                      document.expiryDate,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Document details',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.summary,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ...document.metadata.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildRow(
                          context,
                          Icons.label_outline,
                          entry.key,
                          entry.value,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Document preview',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.previewNote,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Center(
                      child: Icon(
                        Icons.document_scanner_rounded,
                        size: 72,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    key: const Key('analyzeOcrButton'),
                    onPressed: _isAnalyzing ? null : _startOcrAnalysis,
                    icon: const Icon(Icons.auto_fix_high_rounded),
                    label: _isAnalyzing
                        ? const Text('Analyzing...')
                        : const Text('Analyze OCR data'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_showOcrAnalysis ||
                document.ocrExtractedText.trim().isNotEmpty) ...[
              Text(
                'OCR analysis',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        document.ocrExtractedText,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        key: const Key('copyOcrTextButton'),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: document.ocrExtractedText),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('OCR text copied to clipboard.'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy_all_rounded),
                        label: const Text('Copy OCR text'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _toggleFavoriteDocument(BuildContext context, Document document) {
    final updatedDocument = document.copyWith(isFavorite: !document.isFavorite);
    ref
        .read(documentsNotifierProvider.notifier)
        .updateDocument(updatedDocument);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${document.title} ${updatedDocument.isFavorite ? 'added to favorites' : 'removed from favorites'}.',
        ),
      ),
    );
  }

  void _toggleArchiveDocument(BuildContext context, Document document) {
    final updatedDocument = document.copyWith(isArchived: !document.isArchived);
    ref
        .read(documentsNotifierProvider.notifier)
        .updateDocument(updatedDocument);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${document.title} ${updatedDocument.isArchived ? 'archived' : 'restored'}.',
        ),
      ),
    );
    if (updatedDocument.isArchived) {
      GoRouter.of(context).go('/documents');
    }
  }

  void _duplicateDocument(BuildContext context, Document document) {
    final duplicate = document.copyWith(
      id: '${document.id}_copy_${DateTime.now().millisecondsSinceEpoch}',
      title: '${document.title} (Copy)',
      isPinned: false,
      reminderSet: false,
    );
    ref.read(documentsNotifierProvider.notifier).addDocument(duplicate);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${duplicate.title} added to your documents.')),
    );
  }

  void _shareDocument(BuildContext context, Document document) {
    final shareText =
        '''Document: ${document.title}\nCategory: ${document.category}\nExpiry: ${document.expiryDate}\n\nOCR: ${document.ocrExtractedText}''';
    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document details copied for sharing.')),
    );
  }

  void _exportDocument(BuildContext context, Document document) {
    final exportText =
        '''Document export\nTitle: ${document.title}\nCategory: ${document.category}\nIssuer: ${document.issuer}\nIssued: ${document.issuedDate}\nExpiry: ${document.expiryDate}\nHolder: ${document.holderName}\nNumber: ${document.documentNumber}\n\nSummary:\n${document.summary}\n\nOCR:\n${document.ocrExtractedText}''';
    Clipboard.setData(ClipboardData(text: exportText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document exported to clipboard.')),
    );
  }

  void _setExpiryReminder(BuildContext context, Document document) {
    final updatedDocument = document.copyWith(
      reminderSet: !document.reminderSet,
    );
    ref
        .read(documentsNotifierProvider.notifier)
        .updateDocument(updatedDocument);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reminder ${updatedDocument.reminderSet ? 'set' : 'cleared'} for ${document.title} before expiry.',
        ),
      ),
    );
  }

  void _togglePinDocument(BuildContext context, Document document) {
    final updatedDocument = document.copyWith(isPinned: !document.isPinned);
    ref
        .read(documentsNotifierProvider.notifier)
        .updateDocument(updatedDocument);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${document.title} ${updatedDocument.isPinned ? 'pinned' : 'unpinned'}.',
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, Document document) async {
    final controller = TextEditingController(text: document.title);
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit document'),
          content: TextField(
            key: const Key('editDocumentTitleField'),
            controller: controller,
            decoration: const InputDecoration(labelText: 'Document title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const Key('saveEditedDocumentButton'),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (shouldSave != true) return;

    final updatedTitle = controller.text.trim();
    if (updatedTitle.isEmpty) return;

    ref
        .read(documentsNotifierProvider.notifier)
        .updateDocument(document.copyWith(title: updatedTitle));
  }

  Future<void> _confirmDelete(BuildContext context, Document document) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete document'),
          content: const Text(
            'Are you sure you want to delete this document? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              key: const Key('cancelDeleteButton'),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const Key('confirmDeleteButton'),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;
    if (!context.mounted) return;

    ref.read(documentsNotifierProvider.notifier).removeDocument(document.id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Document deleted.')));
    GoRouter.of(context).go('/documents');
  }

  Widget _buildRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 6),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
