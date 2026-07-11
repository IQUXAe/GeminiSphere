// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Failure {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) server,
    required TResult Function(String message) audio,
    required TResult Function(String message) wakeWord,
    required TResult Function(String message) storage,
    required TResult Function(String message) permission,
    required TResult Function(String message) network,
    required TResult Function(String message) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? server,
    TResult? Function(String message)? audio,
    TResult? Function(String message)? wakeWord,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? network,
    TResult? Function(String message)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? server,
    TResult Function(String message)? audio,
    TResult Function(String message)? wakeWord,
    TResult Function(String message)? storage,
    TResult Function(String message)? permission,
    TResult Function(String message)? network,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(AudioFailure value) audio,
    required TResult Function(WakeWordFailure value) wakeWord,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnknownFailure value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(AudioFailure value)? audio,
    TResult? Function(WakeWordFailure value)? wakeWord,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnknownFailure value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(AudioFailure value)? audio,
    TResult Function(WakeWordFailure value)? wakeWord,
    TResult Function(StorageFailure value)? storage,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FailureCopyWith<Failure> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServerFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$ServerFailureImplCopyWith(
          _$ServerFailureImpl value, $Res Function(_$ServerFailureImpl) then) =
      __$$ServerFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ServerFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ServerFailureImpl>
    implements _$$ServerFailureImplCopyWith<$Res> {
  __$$ServerFailureImplCopyWithImpl(
      _$ServerFailureImpl _value, $Res Function(_$ServerFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ServerFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ServerFailureImpl implements ServerFailure {
  const _$ServerFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.server(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      __$$ServerFailureImplCopyWithImpl<_$ServerFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) server,
    required TResult Function(String message) audio,
    required TResult Function(String message) wakeWord,
    required TResult Function(String message) storage,
    required TResult Function(String message) permission,
    required TResult Function(String message) network,
    required TResult Function(String message) unknown,
  }) {
    return server(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? server,
    TResult? Function(String message)? audio,
    TResult? Function(String message)? wakeWord,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? network,
    TResult? Function(String message)? unknown,
  }) {
    return server?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? server,
    TResult Function(String message)? audio,
    TResult Function(String message)? wakeWord,
    TResult Function(String message)? storage,
    TResult Function(String message)? permission,
    TResult Function(String message)? network,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(AudioFailure value) audio,
    required TResult Function(WakeWordFailure value) wakeWord,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return server(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(AudioFailure value)? audio,
    TResult? Function(WakeWordFailure value)? wakeWord,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return server?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(AudioFailure value)? audio,
    TResult Function(WakeWordFailure value)? wakeWord,
    TResult Function(StorageFailure value)? storage,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(this);
    }
    return orElse();
  }
}

abstract class ServerFailure implements Failure {
  const factory ServerFailure({required final String message}) =
      _$ServerFailureImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AudioFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$AudioFailureImplCopyWith(
          _$AudioFailureImpl value, $Res Function(_$AudioFailureImpl) then) =
      __$$AudioFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AudioFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$AudioFailureImpl>
    implements _$$AudioFailureImplCopyWith<$Res> {
  __$$AudioFailureImplCopyWithImpl(
      _$AudioFailureImpl _value, $Res Function(_$AudioFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$AudioFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AudioFailureImpl implements AudioFailure {
  const _$AudioFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.audio(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioFailureImplCopyWith<_$AudioFailureImpl> get copyWith =>
      __$$AudioFailureImplCopyWithImpl<_$AudioFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) server,
    required TResult Function(String message) audio,
    required TResult Function(String message) wakeWord,
    required TResult Function(String message) storage,
    required TResult Function(String message) permission,
    required TResult Function(String message) network,
    required TResult Function(String message) unknown,
  }) {
    return audio(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? server,
    TResult? Function(String message)? audio,
    TResult? Function(String message)? wakeWord,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? network,
    TResult? Function(String message)? unknown,
  }) {
    return audio?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? server,
    TResult Function(String message)? audio,
    TResult Function(String message)? wakeWord,
    TResult Function(String message)? storage,
    TResult Function(String message)? permission,
    TResult Function(String message)? network,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (audio != null) {
      return audio(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(AudioFailure value) audio,
    required TResult Function(WakeWordFailure value) wakeWord,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return audio(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(AudioFailure value)? audio,
    TResult? Function(WakeWordFailure value)? wakeWord,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return audio?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(AudioFailure value)? audio,
    TResult Function(WakeWordFailure value)? wakeWord,
    TResult Function(StorageFailure value)? storage,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (audio != null) {
      return audio(this);
    }
    return orElse();
  }
}

abstract class AudioFailure implements Failure {
  const factory AudioFailure({required final String message}) =
      _$AudioFailureImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$AudioFailureImplCopyWith<_$AudioFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WakeWordFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$WakeWordFailureImplCopyWith(_$WakeWordFailureImpl value,
          $Res Function(_$WakeWordFailureImpl) then) =
      __$$WakeWordFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$WakeWordFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$WakeWordFailureImpl>
    implements _$$WakeWordFailureImplCopyWith<$Res> {
  __$$WakeWordFailureImplCopyWithImpl(
      _$WakeWordFailureImpl _value, $Res Function(_$WakeWordFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$WakeWordFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$WakeWordFailureImpl implements WakeWordFailure {
  const _$WakeWordFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.wakeWord(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WakeWordFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WakeWordFailureImplCopyWith<_$WakeWordFailureImpl> get copyWith =>
      __$$WakeWordFailureImplCopyWithImpl<_$WakeWordFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) server,
    required TResult Function(String message) audio,
    required TResult Function(String message) wakeWord,
    required TResult Function(String message) storage,
    required TResult Function(String message) permission,
    required TResult Function(String message) network,
    required TResult Function(String message) unknown,
  }) {
    return wakeWord(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? server,
    TResult? Function(String message)? audio,
    TResult? Function(String message)? wakeWord,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? network,
    TResult? Function(String message)? unknown,
  }) {
    return wakeWord?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? server,
    TResult Function(String message)? audio,
    TResult Function(String message)? wakeWord,
    TResult Function(String message)? storage,
    TResult Function(String message)? permission,
    TResult Function(String message)? network,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (wakeWord != null) {
      return wakeWord(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(AudioFailure value) audio,
    required TResult Function(WakeWordFailure value) wakeWord,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return wakeWord(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(AudioFailure value)? audio,
    TResult? Function(WakeWordFailure value)? wakeWord,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return wakeWord?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(AudioFailure value)? audio,
    TResult Function(WakeWordFailure value)? wakeWord,
    TResult Function(StorageFailure value)? storage,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (wakeWord != null) {
      return wakeWord(this);
    }
    return orElse();
  }
}

abstract class WakeWordFailure implements Failure {
  const factory WakeWordFailure({required final String message}) =
      _$WakeWordFailureImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$WakeWordFailureImplCopyWith<_$WakeWordFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StorageFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$StorageFailureImplCopyWith(_$StorageFailureImpl value,
          $Res Function(_$StorageFailureImpl) then) =
      __$$StorageFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$StorageFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$StorageFailureImpl>
    implements _$$StorageFailureImplCopyWith<$Res> {
  __$$StorageFailureImplCopyWithImpl(
      _$StorageFailureImpl _value, $Res Function(_$StorageFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$StorageFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StorageFailureImpl implements StorageFailure {
  const _$StorageFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.storage(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorageFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StorageFailureImplCopyWith<_$StorageFailureImpl> get copyWith =>
      __$$StorageFailureImplCopyWithImpl<_$StorageFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) server,
    required TResult Function(String message) audio,
    required TResult Function(String message) wakeWord,
    required TResult Function(String message) storage,
    required TResult Function(String message) permission,
    required TResult Function(String message) network,
    required TResult Function(String message) unknown,
  }) {
    return storage(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? server,
    TResult? Function(String message)? audio,
    TResult? Function(String message)? wakeWord,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? network,
    TResult? Function(String message)? unknown,
  }) {
    return storage?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? server,
    TResult Function(String message)? audio,
    TResult Function(String message)? wakeWord,
    TResult Function(String message)? storage,
    TResult Function(String message)? permission,
    TResult Function(String message)? network,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(AudioFailure value) audio,
    required TResult Function(WakeWordFailure value) wakeWord,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return storage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(AudioFailure value)? audio,
    TResult? Function(WakeWordFailure value)? wakeWord,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return storage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(AudioFailure value)? audio,
    TResult Function(WakeWordFailure value)? wakeWord,
    TResult Function(StorageFailure value)? storage,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage(this);
    }
    return orElse();
  }
}

abstract class StorageFailure implements Failure {
  const factory StorageFailure({required final String message}) =
      _$StorageFailureImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$StorageFailureImplCopyWith<_$StorageFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PermissionFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$PermissionFailureImplCopyWith(_$PermissionFailureImpl value,
          $Res Function(_$PermissionFailureImpl) then) =
      __$$PermissionFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PermissionFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$PermissionFailureImpl>
    implements _$$PermissionFailureImplCopyWith<$Res> {
  __$$PermissionFailureImplCopyWithImpl(_$PermissionFailureImpl _value,
      $Res Function(_$PermissionFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$PermissionFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PermissionFailureImpl implements PermissionFailure {
  const _$PermissionFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.permission(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionFailureImplCopyWith<_$PermissionFailureImpl> get copyWith =>
      __$$PermissionFailureImplCopyWithImpl<_$PermissionFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) server,
    required TResult Function(String message) audio,
    required TResult Function(String message) wakeWord,
    required TResult Function(String message) storage,
    required TResult Function(String message) permission,
    required TResult Function(String message) network,
    required TResult Function(String message) unknown,
  }) {
    return permission(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? server,
    TResult? Function(String message)? audio,
    TResult? Function(String message)? wakeWord,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? network,
    TResult? Function(String message)? unknown,
  }) {
    return permission?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? server,
    TResult Function(String message)? audio,
    TResult Function(String message)? wakeWord,
    TResult Function(String message)? storage,
    TResult Function(String message)? permission,
    TResult Function(String message)? network,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(AudioFailure value) audio,
    required TResult Function(WakeWordFailure value) wakeWord,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return permission(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(AudioFailure value)? audio,
    TResult? Function(WakeWordFailure value)? wakeWord,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return permission?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(AudioFailure value)? audio,
    TResult Function(WakeWordFailure value)? wakeWord,
    TResult Function(StorageFailure value)? storage,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(this);
    }
    return orElse();
  }
}

abstract class PermissionFailure implements Failure {
  const factory PermissionFailure({required final String message}) =
      _$PermissionFailureImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$PermissionFailureImplCopyWith<_$PermissionFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(_$NetworkFailureImpl value,
          $Res Function(_$NetworkFailureImpl) then) =
      __$$NetworkFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
      _$NetworkFailureImpl _value, $Res Function(_$NetworkFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$NetworkFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NetworkFailureImpl implements NetworkFailure {
  const _$NetworkFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.network(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      __$$NetworkFailureImplCopyWithImpl<_$NetworkFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) server,
    required TResult Function(String message) audio,
    required TResult Function(String message) wakeWord,
    required TResult Function(String message) storage,
    required TResult Function(String message) permission,
    required TResult Function(String message) network,
    required TResult Function(String message) unknown,
  }) {
    return network(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? server,
    TResult? Function(String message)? audio,
    TResult? Function(String message)? wakeWord,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? network,
    TResult? Function(String message)? unknown,
  }) {
    return network?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? server,
    TResult Function(String message)? audio,
    TResult Function(String message)? wakeWord,
    TResult Function(String message)? storage,
    TResult Function(String message)? permission,
    TResult Function(String message)? network,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(AudioFailure value) audio,
    required TResult Function(WakeWordFailure value) wakeWord,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(AudioFailure value)? audio,
    TResult? Function(WakeWordFailure value)? wakeWord,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(AudioFailure value)? audio,
    TResult Function(WakeWordFailure value)? wakeWord,
    TResult Function(StorageFailure value)? storage,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkFailure implements Failure {
  const factory NetworkFailure({required final String message}) =
      _$NetworkFailureImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$UnknownFailureImplCopyWith(_$UnknownFailureImpl value,
          $Res Function(_$UnknownFailureImpl) then) =
      __$$UnknownFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UnknownFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnknownFailureImpl>
    implements _$$UnknownFailureImplCopyWith<$Res> {
  __$$UnknownFailureImplCopyWithImpl(
      _$UnknownFailureImpl _value, $Res Function(_$UnknownFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$UnknownFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UnknownFailureImpl implements UnknownFailure {
  const _$UnknownFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.unknown(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      __$$UnknownFailureImplCopyWithImpl<_$UnknownFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) server,
    required TResult Function(String message) audio,
    required TResult Function(String message) wakeWord,
    required TResult Function(String message) storage,
    required TResult Function(String message) permission,
    required TResult Function(String message) network,
    required TResult Function(String message) unknown,
  }) {
    return unknown(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? server,
    TResult? Function(String message)? audio,
    TResult? Function(String message)? wakeWord,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? network,
    TResult? Function(String message)? unknown,
  }) {
    return unknown?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? server,
    TResult Function(String message)? audio,
    TResult Function(String message)? wakeWord,
    TResult Function(String message)? storage,
    TResult Function(String message)? permission,
    TResult Function(String message)? network,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(AudioFailure value) audio,
    required TResult Function(WakeWordFailure value) wakeWord,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(AudioFailure value)? audio,
    TResult? Function(WakeWordFailure value)? wakeWord,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(AudioFailure value)? audio,
    TResult Function(WakeWordFailure value)? wakeWord,
    TResult Function(StorageFailure value)? storage,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownFailure implements Failure {
  const factory UnknownFailure({required final String message}) =
      _$UnknownFailureImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
