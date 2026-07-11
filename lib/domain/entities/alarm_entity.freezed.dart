// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alarm_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AlarmEntity {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  int get hour => throw _privateConstructorUsedError;
  int get minute => throw _privateConstructorUsedError;
  DateTime get scheduledTime => throw _privateConstructorUsedError;
  bool get isFired => throw _privateConstructorUsedError;
  bool get isCancelled => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AlarmEntityCopyWith<AlarmEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlarmEntityCopyWith<$Res> {
  factory $AlarmEntityCopyWith(
          AlarmEntity value, $Res Function(AlarmEntity) then) =
      _$AlarmEntityCopyWithImpl<$Res, AlarmEntity>;
  @useResult
  $Res call(
      {String id,
      String label,
      int hour,
      int minute,
      DateTime scheduledTime,
      bool isFired,
      bool isCancelled});
}

/// @nodoc
class _$AlarmEntityCopyWithImpl<$Res, $Val extends AlarmEntity>
    implements $AlarmEntityCopyWith<$Res> {
  _$AlarmEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? hour = null,
    Object? minute = null,
    Object? scheduledTime = null,
    Object? isFired = null,
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
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFired: null == isFired
          ? _value.isFired
          : isFired // ignore: cast_nullable_to_non_nullable
              as bool,
      isCancelled: null == isCancelled
          ? _value.isCancelled
          : isCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlarmEntityImplCopyWith<$Res>
    implements $AlarmEntityCopyWith<$Res> {
  factory _$$AlarmEntityImplCopyWith(
          _$AlarmEntityImpl value, $Res Function(_$AlarmEntityImpl) then) =
      __$$AlarmEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String label,
      int hour,
      int minute,
      DateTime scheduledTime,
      bool isFired,
      bool isCancelled});
}

/// @nodoc
class __$$AlarmEntityImplCopyWithImpl<$Res>
    extends _$AlarmEntityCopyWithImpl<$Res, _$AlarmEntityImpl>
    implements _$$AlarmEntityImplCopyWith<$Res> {
  __$$AlarmEntityImplCopyWithImpl(
      _$AlarmEntityImpl _value, $Res Function(_$AlarmEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? hour = null,
    Object? minute = null,
    Object? scheduledTime = null,
    Object? isFired = null,
    Object? isCancelled = null,
  }) {
    return _then(_$AlarmEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFired: null == isFired
          ? _value.isFired
          : isFired // ignore: cast_nullable_to_non_nullable
              as bool,
      isCancelled: null == isCancelled
          ? _value.isCancelled
          : isCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AlarmEntityImpl extends _AlarmEntity {
  const _$AlarmEntityImpl(
      {required this.id,
      required this.label,
      required this.hour,
      required this.minute,
      required this.scheduledTime,
      this.isFired = false,
      this.isCancelled = false})
      : super._();

  @override
  final String id;
  @override
  final String label;
  @override
  final int hour;
  @override
  final int minute;
  @override
  final DateTime scheduledTime;
  @override
  @JsonKey()
  final bool isFired;
  @override
  @JsonKey()
  final bool isCancelled;

  @override
  String toString() {
    return 'AlarmEntity(id: $id, label: $label, hour: $hour, minute: $minute, scheduledTime: $scheduledTime, isFired: $isFired, isCancelled: $isCancelled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlarmEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.isFired, isFired) || other.isFired == isFired) &&
            (identical(other.isCancelled, isCancelled) ||
                other.isCancelled == isCancelled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, label, hour, minute,
      scheduledTime, isFired, isCancelled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AlarmEntityImplCopyWith<_$AlarmEntityImpl> get copyWith =>
      __$$AlarmEntityImplCopyWithImpl<_$AlarmEntityImpl>(this, _$identity);
}

abstract class _AlarmEntity extends AlarmEntity {
  const factory _AlarmEntity(
      {required final String id,
      required final String label,
      required final int hour,
      required final int minute,
      required final DateTime scheduledTime,
      final bool isFired,
      final bool isCancelled}) = _$AlarmEntityImpl;
  const _AlarmEntity._() : super._();

  @override
  String get id;
  @override
  String get label;
  @override
  int get hour;
  @override
  int get minute;
  @override
  DateTime get scheduledTime;
  @override
  bool get isFired;
  @override
  bool get isCancelled;
  @override
  @JsonKey(ignore: true)
  _$$AlarmEntityImplCopyWith<_$AlarmEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
