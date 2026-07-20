import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_1/features/documents/data/documents_notifier.dart';
import 'package:flutter_application_1/core/models/document.dart';
import 'package:uuid/uuid.dart';

class DocumentUploadSheet extends StatefulWidget {
  const DocumentUploadSheet({required this.ref, super.key});

  final WidgetRef ref;

  @override
  State<DocumentUploadSheet> createState() => _DocumentUploadSheetState();
}

class _DocumentUploadSheetState extends State<DocumentUploadSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _holderController = TextEditingController();
  final _numberController = TextEditingController();
  final _issuedController = TextEditingController();
  final _expiryController = TextEditingController();
  final _ocrController = TextEditingController();
  String _category = 'Identity';

  @override
  void dispose() {
    _titleController.dispose();
    _holderController.dispose();
    _numberController.dispose();
    _issuedController.dispose();
    _expiryController.dispose();
    _ocrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Import document',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                const Text('Enter document details to save a secure record.'),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('documentTitleField'),
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Document title',
                  ),
                  validator: (value) =>
                      value?.trim().isEmpty == true ? 'Enter a title' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('documentHolderField'),
                  controller: _holderController,
                  decoration: const InputDecoration(labelText: 'Holder name'),
                  validator: (value) => value?.trim().isEmpty == true
                      ? 'Enter the holder name'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('documentNumberField'),
                  controller: _numberController,
                  decoration: const InputDecoration(
                    labelText: 'Document number',
                  ),
                  validator: (value) => value?.trim().isEmpty == true
                      ? 'Enter the document number'
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Identity',
                      child: Text('Identity'),
                    ),
                    DropdownMenuItem(value: 'Medical', child: Text('Medical')),
                    DropdownMenuItem(value: 'Travel', child: Text('Travel')),
                    DropdownMenuItem(
                      value: 'Financial',
                      child: Text('Financial'),
                    ),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _category = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('documentIssuedField'),
                  controller: _issuedController,
                  decoration: const InputDecoration(
                    labelText: 'Issued date (YYYY-MM-DD)',
                  ),
                  validator: (value) => value?.trim().isEmpty == true
                      ? 'Enter the issued date'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('documentExpiryField'),
                  controller: _expiryController,
                  decoration: const InputDecoration(
                    labelText: 'Expiry date (YYYY-MM-DD)',
                  ),
                  validator: (value) => value?.trim().isEmpty == true
                      ? 'Enter the expiry date'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('documentOcrField'),
                  controller: _ocrController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'OCR extracted text (optional)',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  key: const Key('saveDocumentButton'),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    final id =
                        '${_titleController.text.trim().toLowerCase().replaceAll(RegExp(r"[^a-z0-9]+"), '_')}_${DateTime.now().millisecondsSinceEpoch}';
                    widget.ref
                        .read(documentsNotifierProvider.notifier)
                        .addDocument(
                          Document(
                            id: id,
                            title: _titleController.text.trim(),
                            category: _category,
                            issuer: 'Imported document',
                            issuedDate: _issuedController.text.trim(),
                            expiryDate: _expiryController.text.trim(),
                            holderName: _holderController.text.trim(),
                            documentNumber: _numberController.text.trim(),
                            summary:
                                'Imported document metadata saved for AI assist and recall.',
                            previewNote:
                                'Preview saved and ready for OCR analysis.',
                            ocrExtractedText: _ocrController.text.trim().isEmpty
                                ? 'Imported OCR text is ready for AI extraction.'
                                : _ocrController.text.trim(),
                            iconCodePoint: (_category == 'Medical'
                                ? Icons.local_hospital_rounded
                                : _category == 'Travel'
                                ? Icons.flight_takeoff_rounded
                                : _category == 'Financial'
                                ? Icons.account_balance_wallet_rounded
                                : Icons.document_scanner_rounded).codePoint,
                            metadata: {
                              'Category': _category,
                              'Issuer': 'Imported document',
                              'Preview status': 'Ready',
                            },
                          ),
                        );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Document saved successfully.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save document'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
