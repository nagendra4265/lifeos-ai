// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PasswordEntry _$PasswordEntryFromJson(Map<String, dynamic> json) {
  return _PasswordEntry.fromJson(json);
}

/// @nodoc
mixin _$PasswordEntry {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get site => throw _privateConstructorUsedError;
  @HiveField(2)
  String get username => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get password => throw _privateConstructorUsedError;
  @HiveField(4)
  String get category => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PasswordEntryCopyWith<PasswordEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordEntryCopyWith<$Res> {
  factory $PasswordEntryCopyWith(
          PasswordEntry value, $Res Function(PasswordEntry) then) =
      _$PasswordEntryCopyWithImpl<$Res, PasswordEntry>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String site,
      @HiveField(2) String username,
      @HiveField(3) String? password,
      @HiveField(4) String category});
}

/// @nodoc
class _$PasswordEntryCopyWithImpl<$Res, $Val extends PasswordEntry>
    implements $PasswordEntryCopyWith<$Res> {
  _$PasswordEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? site = null,
    Object? username = null,
    Object? password = freezed,
    Object? category = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      site: null == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PasswordEntryImplCopyWith<$Res>
    implements $PasswordEntryCopyWith<$Res> {
  factory _$$PasswordEntryImplCopyWith(
          _$PasswordEntryImpl value, $Res Function(_$PasswordEntryImpl) then) =
      __$$PasswordEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String site,
      @HiveField(2) String username,
      @HiveField(3) String? password,
      @HiveField(4) String category});
}

/// @nodoc
class __$$PasswordEntryImplCopyWithImpl<$Res>
    extends _$PasswordEntryCopyWithImpl<$Res, _$PasswordEntryImpl>
    implements _$$PasswordEntryImplCopyWith<$Res> {
  __$$PasswordEntryImplCopyWithImpl(
      _$PasswordEntryImpl _value, $Res Function(_$PasswordEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? site = null,
    Object? username = null,
    Object? password = freezed,
    Object? category = null,
  }) {
    return _then(_$PasswordEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      site: null == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PasswordEntryImpl implements _PasswordEntry {
  const _$PasswordEntryImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.site,
      @HiveField(2) required this.username,
      @HiveField(3) this.password,
      @HiveField(4) this.category = 'Others'});

  factory _$PasswordEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PasswordEntryImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String site;
  @override
  @HiveField(2)
  final String username;
  @override
  @HiveField(3)
  final String? password;
  @override
  @JsonKey()
  @HiveField(4)
  final String category;

  @override
  String toString() {
    return 'PasswordEntry(id: $id, site: $site, username: $username, password: $password, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.site, site) || other.site == site) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, site, username, password, category);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordEntryImplCopyWith<_$PasswordEntryImpl> get copyWith =>
      __$$PasswordEntryImplCopyWithImpl<_$PasswordEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PasswordEntryImplToJson(
      this,
    );
  }
}

abstract class _PasswordEntry implements PasswordEntry {
  const factory _PasswordEntry(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String site,
      @HiveField(2) required final String username,
      @HiveField(3) final String? password,
      @HiveField(4) final String category}) = _$PasswordEntryImpl;

  factory _PasswordEntry.fromJson(Map<String, dynamic> json) =
      _$PasswordEntryImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get site;
  @override
  @HiveField(2)
  String get username;
  @override
  @HiveField(3)
  String? get password;
  @override
  @HiveField(4)
  String get category;
  @override
  @JsonKey(ignore: true)
  _$$PasswordEntryImplCopyWith<_$PasswordEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
