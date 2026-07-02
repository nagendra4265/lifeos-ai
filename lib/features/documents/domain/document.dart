import 'package:flutter/material.dart';

class Document {
  const Document({
    required this.id,
    required this.title,
    required this.category,
    required this.issuer,
    required this.issuedDate,
    required this.expiryDate,
    required this.holderName,
    required this.documentNumber,
    required this.summary,
    required this.previewNote,
    required this.ocrExtractedText,
    required this.icon,
    required this.metadata,
    this.isPinned = false,
    this.reminderSet = false,
    this.isFavorite = false,
    this.isArchived = false,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String category;
  final String issuer;
  final String issuedDate;
  final String expiryDate;
  final String holderName;
  final String documentNumber;
  final String summary;
  final String previewNote;
  final String ocrExtractedText;
  final IconData icon;
  final Map<String, String> metadata;
  final bool isPinned;
  final bool reminderSet;
  final bool isFavorite;
  final bool isArchived;
  final List<String> tags;

  Document copyWith({
    String? id,
    String? title,
    String? category,
    String? issuer,
    String? issuedDate,
    String? expiryDate,
    String? holderName,
    String? documentNumber,
    String? summary,
    String? previewNote,
    String? ocrExtractedText,
    IconData? icon,
    Map<String, String>? metadata,
    bool? isPinned,
    bool? reminderSet,
    bool? isFavorite,
    bool? isArchived,
    List<String>? tags,
  }) {
    return Document(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      issuer: issuer ?? this.issuer,
      issuedDate: issuedDate ?? this.issuedDate,
      expiryDate: expiryDate ?? this.expiryDate,
      holderName: holderName ?? this.holderName,
      documentNumber: documentNumber ?? this.documentNumber,
      summary: summary ?? this.summary,
      previewNote: previewNote ?? this.previewNote,
      ocrExtractedText: ocrExtractedText ?? this.ocrExtractedText,
      icon: icon ?? this.icon,
      metadata: metadata ?? this.metadata,
      isPinned: isPinned ?? this.isPinned,
      reminderSet: reminderSet ?? this.reminderSet,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      tags: tags ?? this.tags,
    );
  }

  bool get isExpired {
    final expiry = DateTime.tryParse(expiryDate);
    if (expiry == null) return false;
    return expiry.isBefore(DateTime.now());
  }

  int get daysUntilExpiry {
    final expiry = DateTime.tryParse(expiryDate);
    if (expiry == null) return 0;
    return expiry.difference(DateTime.now()).inDays;
  }
}
