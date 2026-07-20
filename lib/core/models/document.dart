import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'document.freezed.dart';
part 'document.g.dart';

@freezed
@HiveType(typeId: 5)
class Document with _$Document {
  const Document._();

  const factory Document({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required String category,
    @HiveField(3) @Default('') String issuer,
    @HiveField(4) @Default('') String issuedDate,
    @HiveField(5) @Default('') String expiryDate,
    @HiveField(6) @Default('') String holderName,
    @HiveField(7) @Default('') String documentNumber,
    @HiveField(8) @Default('') String summary,
    @HiveField(9) @Default('') String previewNote,
    @HiveField(10) @Default('') String ocrExtractedText,
    @HiveField(11) @Default(0) int iconCodePoint,
    @HiveField(12) @Default({}) Map<String, String> metadata,
    @HiveField(13) @Default(false) bool isPinned,
    @HiveField(14) @Default(false) bool reminderSet,
    @HiveField(15) @Default(false) bool isFavorite,
    @HiveField(16) @Default(false) bool isArchived,
    @HiveField(17) @Default([]) List<String> tags,
  }) = _Document;

  factory Document.fromJson(Map<String, dynamic> json) => _$DocumentFromJson(json);

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
