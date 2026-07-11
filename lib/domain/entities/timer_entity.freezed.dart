// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TimerEntity {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  int get durationSeconds => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get firedAt => throw _privateConstructorUsedError;
  bool get isCancelled => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TimerEntityCopyWith<TimerEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimerEntityCopyWith<$Res> {
  factory $TimerEntityCopyWith(
          TimerEntity value, $Res Function(TimerEntity) then) =
      _$TimerEntityCopyWithImpl<$Res, TimerEntity>;
  @useResult
  $Res call(
      {String id,
      String label,
      int durationSeconds,
      DateTime createdAt,
      DateTime? firedAt,
      bool isCancelled});
}

/// @nodoc
class _$TimerEntityCopyWithImpl<$Res, $Val extends TimerEntity>
    implements $TimerEntityCopyWith<$Res> {
  _$TimerEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? durationSeconds = null,
    Object? createdAt = null,
    Object? firedAt = freezed,
    Object? isCancelled = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      firedAt: freezed == firedAt
          ? _value.firedAt
          : firedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCancelled: null == isCancelled
          ? _value.isCancelled
          : isCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimerEntityImplCopyWith<$Res>
    implements $TimerEntityCopyWith<$Res> {
  factory _$$TimerEntityImplCopyWith(
          _$TimerEntityImpl value, $Res Function(_$TimerEntityImpl) then) =
      __$$TimerEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String label,
      int durationSeconds,
      DateTime createdAt,
      DateTime? firedAt,
      bool isCancelled});
}

/// @nodoc
class __$$TimerEntityImplCopyWithImpl<$Res>
    extends _$TimerEntityCopyWithImpl<$Res, _$TimerEntityImpl>
    implements _$$TimerEntityImplCopyWith<$Res> {
  __$$TimerEntityImplCopyWithImpl(
      _$TimerEntityImpl _value, $Res Function(_$TimerEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? durationSeconds = null,
    Object? createdAt = null,
    Object? firedAt = freezed,
    Object? isCancelled = null,
  }) {
    return _then(_$TimerEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      firedAt: freezed == firedAt
          ? _value.firedAt
          : firedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCancelled: null == isCancelled
          ? _value.isCancelled
          : isCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$TimerEntityImpl extends _TimerEntity {
  const _$TimerEntityImpl(
      {required this.id,
      required this.label,
      required this.durationSeconds,
      required this.createdAt,
      this.firedAt,
      this.isCancelled = false})
      : super._();

  @override
  final String id;
  @override
  final String label;
  @override
  final int durationSeconds;
  @override
  final DateTime createdAt;
  @override
  final DateTime? firedAt;
  @override
  @JsonKey()
  final bool isCancelled;

  @override
  String toString() {
    return 'TimerEntity(id: $id, label: $label, durationSeconds: $durationSeconds, createdAt: $createdAt, firedAt: $firedAt, isCancelled: $isCancelled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.firedAt, firedAt) || other.firedAt == firedAt) &&
            (identical(other.isCancelled, isCancelled) ||
                other.isCancelled == isCancelled));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, label, durationSeconds, createdAt, firedAt, isCancelled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerEntityImplCopyWith<_$TimerEntityImpl> get copyWith =>
      __$$TimerEntityImplCopyWithImpl<_$TimerEntityImpl>(this, _$identity);
}

abstract class _TimerEntity extends TimerEntity {
  const factory _TimerEntity(
      {required final String id,
      required final String label,
      required final int durationSeconds,
      required final DateTime createdAt,
      final DateTime? firedAt,
      final bool isCancelled}) = _$TimerEntityImpl;
  const _TimerEntity._() : super._();

  @override
  String get id;
  @override
  String get label;
  @override
  int get durationSeconds;
  @override
  DateTime get createdAt;
  @override
  DateTime? get firedAt;
  @override
  bool get isCancelled;
  @override
  @JsonKey(ignore: true)
  _$$TimerEntityImplCopyWith<_$TimerEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
