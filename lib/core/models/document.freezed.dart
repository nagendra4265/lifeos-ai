// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Document _$DocumentFromJson(Map<String, dynamic> json) {
  return _Document.fromJson(json);
}

/// @nodoc
mixin _$Document {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(2)
  String get category => throw _privateConstructorUsedError;
  @HiveField(3)
  String get issuer => throw _privateConstructorUsedError;
  @HiveField(4)
  String get issuedDate => throw _privateConstructorUsedError;
  @HiveField(5)
  String get expiryDate => throw _privateConstructorUsedError;
  @HiveField(6)
  String get holderName => throw _privateConstructorUsedError;
  @HiveField(7)
  String get documentNumber => throw _privateConstructorUsedError;
  @HiveField(8)
  String get summary => throw _privateConstructorUsedError;
  @HiveField(9)
  String get previewNote => throw _privateConstructorUsedError;
  @HiveField(10)
  String get ocrExtractedText => throw _privateConstructorUsedError;
  @HiveField(11)
  int get iconCodePoint => throw _privateConstructorUsedError;
  @HiveField(12)
  Map<String, String> get metadata => throw _privateConstructorUsedError;
  @HiveField(13)
  bool get isPinned => throw _privateConstructorUsedError;
  @HiveField(14)
  bool get reminderSet => throw _privateConstructorUsedError;
  @HiveField(15)
  bool get isFavorite => throw _privateConstructorUsedError;
  @HiveField(16)
  bool get isArchived => throw _privateConstructorUsedError;
  @HiveField(17)
  List<String> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DocumentCopyWith<Document> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentCopyWith<$Res> {
  factory $DocumentCopyWith(Document value, $Res Function(Document) then) =
      _$DocumentCopyWithImpl<$Res, Document>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) String category,
      @HiveField(3) String issuer,
      @HiveField(4) String issuedDate,
      @HiveField(5) String expiryDate,
      @HiveField(6) String holderName,
      @HiveField(7) String documentNumber,
      @HiveField(8) String summary,
      @HiveField(9) String previewNote,
      @HiveField(10) String ocrExtractedText,
      @HiveField(11) int iconCodePoint,
      @HiveField(12) Map<String, String> metadata,
      @HiveField(13) bool isPinned,
      @HiveField(14) bool reminderSet,
      @HiveField(15) bool isFavorite,
      @HiveField(16) bool isArchived,
      @HiveField(17) List<String> tags});
}

/// @nodoc
class _$DocumentCopyWithImpl<$Res, $Val extends Document>
    implements $DocumentCopyWith<$Res> {
  _$DocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? issuer = null,
    Object? issuedDate = null,
    Object? expiryDate = null,
    Object? holderName = null,
    Object? documentNumber = null,
    Object? summary = null,
    Object? previewNote = null,
    Object? ocrExtractedText = null,
    Object? iconCodePoint = null,
    Object? metadata = null,
    Object? isPinned = null,
    Object? reminderSet = null,
    Object? isFavorite = null,
    Object? isArchived = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      issuer: null == issuer
          ? _value.issuer
          : issuer // ignore: cast_nullable_to_non_nullable
              as String,
      issuedDate: null == issuedDate
          ? _value.issuedDate
          : issuedDate // ignore: cast_nullable_to_non_nullable
              as String,
      expiryDate: null == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String,
      holderName: null == holderName
          ? _value.holderName
          : holderName // ignore: cast_nullable_to_non_nullable
              as String,
      documentNumber: null == documentNumber
          ? _value.documentNumber
          : documentNumber // ignore: cast_nullable_to_non_nullable
              as String,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      previewNote: null == previewNote
          ? _value.previewNote
          : previewNote // ignore: cast_nullable_to_non_nullable
              as String,
      ocrExtractedText: null == ocrExtractedText
          ? _value.ocrExtractedText
          : ocrExtractedText // ignore: cast_nullable_to_non_nullable
              as String,
      iconCodePoint: null == iconCodePoint
          ? _value.iconCodePoint
          : iconCodePoint // ignore: cast_nullable_to_non_nullable
              as int,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderSet: null == reminderSet
          ? _value.reminderSet
          : reminderSet // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DocumentImplCopyWith<$Res>
    implements $DocumentCopyWith<$Res> {
  factory _$$DocumentImplCopyWith(
          _$DocumentImpl value, $Res Function(_$DocumentImpl) then) =
      __$$DocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) String category,
      @HiveField(3) String issuer,
      @HiveField(4) String issuedDate,
      @HiveField(5) String expiryDate,
      @HiveField(6) String holderName,
      @HiveField(7) String documentNumber,
      @HiveField(8) String summary,
      @HiveField(9) String previewNote,
      @HiveField(10) String ocrExtractedText,
      @HiveField(11) int iconCodePoint,
      @HiveField(12) Map<String, String> metadata,
      @HiveField(13) bool isPinned,
      @HiveField(14) bool reminderSet,
      @HiveField(15) bool isFavorite,
      @HiveField(16) bool isArchived,
      @HiveField(17) List<String> tags});
}

/// @nodoc
class __$$DocumentImplCopyWithImpl<$Res>
    extends _$DocumentCopyWithImpl<$Res, _$DocumentImpl>
    implements _$$DocumentImplCopyWith<$Res> {
  __$$DocumentImplCopyWithImpl(
      _$DocumentImpl _value, $Res Function(_$DocumentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? issuer = null,
    Object? issuedDate = null,
    Object? expiryDate = null,
    Object? holderName = null,
    Object? documentNumber = null,
    Object? summary = null,
    Object? previewNote = null,
    Object? ocrExtractedText = null,
    Object? iconCodePoint = null,
    Object? metadata = null,
    Object? isPinned = null,
    Object? reminderSet = null,
    Object? isFavorite = null,
    Object? isArchived = null,
    Object? tags = null,
  }) {
    return _then(_$DocumentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      issuer: null == issuer
          ? _value.issuer
          : issuer // ignore: cast_nullable_to_non_nullable
              as String,
      issuedDate: null == issuedDate
          ? _value.issuedDate
          : issuedDate // ignore: cast_nullable_to_non_nullable
              as String,
      expiryDate: null == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String,
      holderName: null == holderName
          ? _value.holderName
          : holderName // ignore: cast_nullable_to_non_nullable
              as String,
      documentNumber: null == documentNumber
          ? _value.documentNumber
          : documentNumber // ignore: cast_nullable_to_non_nullable
              as String,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      previewNote: null == previewNote
          ? _value.previewNote
          : previewNote // ignore: cast_nullable_to_non_nullable
              as String,
      ocrExtractedText: null == ocrExtractedText
          ? _value.ocrExtractedText
          : ocrExtractedText // ignore: cast_nullable_to_non_nullable
              as String,
      iconCodePoint: null == iconCodePoint
          ? _value.iconCodePoint
          : iconCodePoint // ignore: cast_nullable_to_non_nullable
              as int,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderSet: null == reminderSet
          ? _value.reminderSet
          : reminderSet // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentImpl extends _Document {
  const _$DocumentImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(2) required this.category,
      @HiveField(3) this.issuer = '',
      @HiveField(4) this.issuedDate = '',
      @HiveField(5) this.expiryDate = '',
      @HiveField(6) this.holderName = '',
      @HiveField(7) this.documentNumber = '',
      @HiveField(8) this.summary = '',
      @HiveField(9) this.previewNote = '',
      @HiveField(10) this.ocrExtractedText = '',
      @HiveField(11) this.iconCodePoint = 0,
      @HiveField(12) final Map<String, String> metadata = const {},
      @HiveField(13) this.isPinned = false,
      @HiveField(14) this.reminderSet = false,
      @HiveField(15) this.isFavorite = false,
      @HiveField(16) this.isArchived = false,
      @HiveField(17) final List<String> tags = const []})
      : _metadata = metadata,
        _tags = tags,
        super._();

  factory _$DocumentImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final String category;
  @override
  @JsonKey()
  @HiveField(3)
  final String issuer;
  @override
  @JsonKey()
  @HiveField(4)
  final String issuedDate;
  @override
  @JsonKey()
  @HiveField(5)
  final String expiryDate;
  @override
  @JsonKey()
  @HiveField(6)
  final String holderName;
  @override
  @JsonKey()
  @HiveField(7)
  final String documentNumber;
  @override
  @JsonKey()
  @HiveField(8)
  final String summary;
  @override
  @JsonKey()
  @HiveField(9)
  final String previewNote;
  @override
  @JsonKey()
  @HiveField(10)
  final String ocrExtractedText;
  @override
  @JsonKey()
  @HiveField(11)
  final int iconCodePoint;
  final Map<String, String> _metadata;
  @override
  @JsonKey()
  @HiveField(12)
  Map<String, String> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  @JsonKey()
  @HiveField(13)
  final bool isPinned;
  @override
  @JsonKey()
  @HiveField(14)
  final bool reminderSet;
  @override
  @JsonKey()
  @HiveField(15)
  final bool isFavorite;
  @override
  @JsonKey()
  @HiveField(16)
  final bool isArchived;
  final List<String> _tags;
  @override
  @JsonKey()
  @HiveField(17)
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'Document(id: $id, title: $title, category: $category, issuer: $issuer, issuedDate: $issuedDate, expiryDate: $expiryDate, holderName: $holderName, documentNumber: $documentNumber, summary: $summary, previewNote: $previewNote, ocrExtractedText: $ocrExtractedText, iconCodePoint: $iconCodePoint, metadata: $metadata, isPinned: $isPinned, reminderSet: $reminderSet, isFavorite: $isFavorite, isArchived: $isArchived, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.issuer, issuer) || other.issuer == issuer) &&
            (identical(other.issuedDate, issuedDate) ||
                other.issuedDate == issuedDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.holderName, holderName) ||
                other.holderName == holderName) &&
            (identical(other.documentNumber, documentNumber) ||
                other.documentNumber == documentNumber) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.previewNote, previewNote) ||
                other.previewNote == previewNote) &&
            (identical(other.ocrExtractedText, ocrExtractedText) ||
                other.ocrExtractedText == ocrExtractedText) &&
            (identical(other.iconCodePoint, iconCodePoint) ||
                other.iconCodePoint == iconCodePoint) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.reminderSet, reminderSet) ||
                other.reminderSet == reminderSet) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      category,
      issuer,
      issuedDate,
      expiryDate,
      holderName,
      documentNumber,
      summary,
      previewNote,
      ocrExtractedText,
      iconCodePoint,
      const DeepCollectionEquality().hash(_metadata),
      isPinned,
      reminderSet,
      isFavorite,
      isArchived,
      const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentImplCopyWith<_$DocumentImpl> get copyWith =>
      __$$DocumentImplCopyWithImpl<_$DocumentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentImplToJson(
      this,
    );
  }
}

abstract class _Document extends Document {
  const factory _Document(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String title,
      @HiveField(2) required final String category,
      @HiveField(3) final String issuer,
      @HiveField(4) final String issuedDate,
      @HiveField(5) final String expiryDate,
      @HiveField(6) final String holderName,
      @HiveField(7) final String documentNumber,
      @HiveField(8) final String summary,
      @HiveField(9) final String previewNote,
      @HiveField(10) final String ocrExtractedText,
      @HiveField(11) final int iconCodePoint,
      @HiveField(12) final Map<String, String> metadata,
      @HiveField(13) final bool isPinned,
      @HiveField(14) final bool reminderSet,
      @HiveField(15) final bool isFavorite,
      @HiveField(16) final bool isArchived,
      @HiveField(17) final List<String> tags}) = _$DocumentImpl;
  const _Document._() : super._();

  factory _Document.fromJson(Map<String, dynamic> json) =
      _$DocumentImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get title;
  @override
  @HiveField(2)
  String get category;
  @override
  @HiveField(3)
  String get issuer;
  @override
  @HiveField(4)
  String get issuedDate;
  @override
  @HiveField(5)
  String get expiryDate;
  @override
  @HiveField(6)
  String get holderName;
  @override
  @HiveField(7)
  String get documentNumber;
  @override
  @HiveField(8)
  String get summary;
  @override
  @HiveField(9)
  String get previewNote;
  @override
  @HiveField(10)
  String get ocrExtractedText;
  @override
  @HiveField(11)
  int get iconCodePoint;
  @override
  @HiveField(12)
  Map<String, String> get metadata;
  @override
  @HiveField(13)
  bool get isPinned;
  @override
  @HiveField(14)
  bool get reminderSet;
  @override
  @HiveField(15)
  bool get isFavorite;
  @override
  @HiveField(16)
  bool get isArchived;
  @override
  @HiveField(17)
  List<String> get tags;
  @override
  @JsonKey(ignore: true)
  _$$DocumentImplCopyWith<_$DocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
