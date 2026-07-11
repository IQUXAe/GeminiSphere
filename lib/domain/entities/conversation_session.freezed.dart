// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ConversationSession {
  String get id => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  SessionStatus get status => throw _privateConstructorUsedError;
  DateTime? get endedAt => throw _privateConstructorUsedError;
  List<String> get audioChunkIds => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConversationSessionCopyWith<ConversationSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationSessionCopyWith<$Res> {
  factory $ConversationSessionCopyWith(
          ConversationSession value, $Res Function(ConversationSession) then) =
      _$ConversationSessionCopyWithImpl<$Res, ConversationSession>;
  @useResult
  $Res call(
      {String id,
      DateTime startedAt,
      SessionStatus status,
      DateTime? endedAt,
      List<String> audioChunkIds});
}

/// @nodoc
class _$ConversationSessionCopyWithImpl<$Res, $Val extends ConversationSession>
    implements $ConversationSessionCopyWith<$Res> {
  _$ConversationSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startedAt = null,
    Object? status = null,
    Object? endedAt = freezed,
    Object? audioChunkIds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SessionStatus,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      audioChunkIds: null == audioChunkIds
          ? _value.audioChunkIds
          : audioChunkIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationSessionImplCopyWith<$Res>
    implements $ConversationSessionCopyWith<$Res> {
  factory _$$ConversationSessionImplCopyWith(_$ConversationSessionImpl value,
          $Res Function(_$ConversationSessionImpl) then) =
      __$$ConversationSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime startedAt,
      SessionStatus status,
      DateTime? endedAt,
      List<String> audioChunkIds});
}

/// @nodoc
class __$$ConversationSessionImplCopyWithImpl<$Res>
    extends _$ConversationSessionCopyWithImpl<$Res, _$ConversationSessionImpl>
    implements _$$ConversationSessionImplCopyWith<$Res> {
  __$$ConversationSessionImplCopyWithImpl(_$ConversationSessionImpl _value,
      $Res Function(_$ConversationSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startedAt = null,
    Object? status = null,
    Object? endedAt = freezed,
    Object? audioChunkIds = null,
  }) {
    return _then(_$ConversationSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SessionStatus,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      audioChunkIds: null == audioChunkIds
          ? _value._audioChunkIds
          : audioChunkIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$ConversationSessionImpl extends _ConversationSession {
  const _$ConversationSessionImpl(
      {required this.id,
      required this.startedAt,
      this.status = SessionStatus.idle,
      this.endedAt,
      final List<String> audioChunkIds = const []})
      : _audioChunkIds = audioChunkIds,
        super._();

  @override
  final String id;
  @override
  final DateTime startedAt;
  @override
  @JsonKey()
  final SessionStatus status;
  @override
  final DateTime? endedAt;
  final List<String> _audioChunkIds;
  @override
  @JsonKey()
  List<String> get audioChunkIds {
    if (_audioChunkIds is EqualUnmodifiableListView) return _audioChunkIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_audioChunkIds);
  }

  @override
  String toString() {
    return 'ConversationSession(id: $id, startedAt: $startedAt, status: $status, endedAt: $endedAt, audioChunkIds: $audioChunkIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            const DeepCollectionEquality()
                .equals(other._audioChunkIds, _audioChunkIds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, startedAt, status, endedAt,
      const DeepCollectionEquality().hash(_audioChunkIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationSessionImplCopyWith<_$ConversationSessionImpl> get copyWith =>
      __$$ConversationSessionImplCopyWithImpl<_$ConversationSessionImpl>(
          this, _$identity);
}

abstract class _ConversationSession extends ConversationSession {
  const factory _ConversationSession(
      {required final String id,
      required final DateTime startedAt,
      final SessionStatus status,
      final DateTime? endedAt,
      final List<String> audioChunkIds}) = _$ConversationSessionImpl;
  const _ConversationSession._() : super._();

  @override
  String get id;
  @override
  DateTime get startedAt;
  @override
  SessionStatus get status;
  @override
  DateTime? get endedAt;
  @override
  List<String> get audioChunkIds;
  @override
  @JsonKey(ignore: true)
  _$$ConversationSessionImplCopyWith<_$ConversationSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
