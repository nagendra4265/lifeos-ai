import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/document.dart';

final documentsNotifierProvider =
    StateNotifierProvider<DocumentsNotifier, List<Document>>(
      (ref) => DocumentsNotifier(),
    );

class DocumentsNotifier extends StateNotifier<List<Document>> {
  DocumentsNotifier()
    : super(const [
        Document(
          id: 'passport',
          title: 'Passport',
          category: 'Identity',
          issuer: 'Government of India',
          issuedDate: '2023-03-18',
          expiryDate: '2028-02-14',
          holderName: 'Rohan Kumar',
          documentNumber: 'X1234567',
          summary:
              'Official passport scan with machine-readable zone (MRZ) and identity fields extracted by OCR.',
          previewNote:
              'AI-ready passport scan with OCR diagnostics and expiry watch.',
          ocrExtractedText:
              'P<INROHANKUMAR<<<<<<<<<<<\nX1234567<8IND9208220M2802140<<<<<<<<<<<<<<04',
          icon: Icons.card_membership_rounded,
          metadata: {
            'Nationality': 'Indian',
            'Date of birth': '1992-08-22',
            'Place of birth': 'Mumbai',
            'MRZ line 1': 'P<INROHANKUMAR<<<<<<<<<<<',
            'MRZ line 2': 'X1234567<8IND9208220M2802140<<<<<<<<<<<<<<04',
          },
          tags: ['travel', 'identity', 'passport'],
        ),
        Document(
          id: 'insurance',
          title: 'Health Insurance',
          category: 'Medical',
          issuer: 'Swasthya Care',
          issuedDate: '2024-09-01',
          expiryDate: '2029-09-01',
          holderName: 'Ananya Sharma',
          documentNumber: 'IN-8293-2026',
          summary:
              'Health insurance policy with family coverage, extracted policy number, and issuer details.',
          previewNote:
              'PDF scan preview with OCR highlights and policy metadata.',
          ocrExtractedText:
              'Policy number: IN-8293-2026\nCoverage limit: ₹25,00,000\nPlan tier: Premium Plus',
          icon: Icons.shield_rounded,
          metadata: {
            'Policy type': 'Family floater',
            'Coverage': '₹25,00,000',
            'Members covered': '4',
            'Plan tier': 'Premium Plus',
          },
          tags: ['insurance', 'medical', 'family'],
        ),
      ]);

  static const Document unknownDocument = Document(
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
    icon: Icons.document_scanner_rounded,
    metadata: {},
    tags: [],
  );

  void addDocument(Document document) {
    state = [...state, document];
  }

  void updateDocument(Document document) {
    state = state
        .map((item) => item.id == document.id ? document : item)
        .toList();
  }

  void removeDocument(String id) {
    state = state.where((document) => document.id != id).toList();
  }
}
