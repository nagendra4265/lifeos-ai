import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/document.dart';
import 'package:flutter_application_1/core/providers/documents_provider.dart';
import 'package:flutter_application_1/core/repositories/documents_repository.dart';

final documentsNotifierProvider =
    StateNotifierProvider<DocumentsNotifier, List<Document>>(
      (ref) => DocumentsNotifier(ref.watch(documentsRepositoryProvider)),
    );

class DocumentsNotifier extends StateNotifier<List<Document>> {
  final DocumentsRepository _repository;
  
  DocumentsNotifier(this._repository) : super(const []) {
    _load();
  }

  static final Document unknownDocument = Document(
    id: 'unknown',
    title: 'Unknown document',
    category: 'Unknown',
    issuer: 'Unknown issuer',
    issuedDate: 'N/A',
    expiryDate: 'N/A',
    holderName: 'N/A',
    documentNumber: 'N/A',
    summary: 'No metadata available for this document.',
    previewNote: 'No preview available.',
    ocrExtractedText: 'No OCR data available.',
    iconCodePoint: Icons.document_scanner_rounded.codePoint,
    metadata: {},
    tags: [],
  );

  Future<void> _load() async {
    final docs = await _repository.getAll();
    if (docs.isEmpty) {
      // Seed with initial data if empty
      final initialDocs = [
        Document(
          id: 'passport',
          title: 'Passport',
          category: 'Identity',
          issuer: 'Government of India',
          issuedDate: '2023-03-18',
          expiryDate: '2028-02-14',
          holderName: 'Rohan Kumar',
          documentNumber: 'X1234567',
          summary: 'Official passport scan with Machine Readable Zone.',
          iconCodePoint: Icons.card_membership_rounded.codePoint,
          metadata: {'Nationality': 'Indian'},
        ),
      ];
      for (var d in initialDocs) {
        await _repository.save(d.id, d);
      }
      state = initialDocs;
    } else {
      state = docs;
    }
  }

  Future<void> addDocument(Document document) async {
    await _repository.save(document.id, document);
    state = await _repository.getAll();
  }

  Future<void> updateDocument(Document document) async {
    await _repository.save(document.id, document);
    state = await _repository.getAll();
  }

  Future<void> removeDocument(String id) async {
    await _repository.delete(id);
    state = await _repository.getAll();
  }
}
