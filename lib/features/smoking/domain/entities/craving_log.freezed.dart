// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'craving_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CravingLog _$CravingLogFromJson(Map<String, dynamic> json) {
  return _CravingLog.fromJson(json);
}

/// @nodoc
mixin _$CravingLog {
  double get intensity => throw _privateConstructorUsedError;
  List<String> get triggers => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool get resolved => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;

  /// Serializes this CravingLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CravingLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CravingLogCopyWith<CravingLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CravingLogCopyWith<$Res> {
  factory $CravingLogCopyWith(
          CravingLog value, $Res Function(CravingLog) then) =
      _$CravingLogCopyWithImpl<$Res, CravingLog>;
  @useResult
  $Res call(
      {double intensity,
      List<String> triggers,
      DateTime timestamp,
      bool resolved,
      DateTime? resolvedAt});
}

/// @nodoc
class _$CravingLogCopyWithImpl<$Res, $Val extends CravingLog>
    implements $CravingLogCopyWith<$Res> {
  _$CravingLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CravingLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intensity = null,
    Object? triggers = null,
    Object? timestamp = null,
    Object? resolved = null,
    Object? resolvedAt = freezed,
  }) {
    return _then(_value.copyWith(
      intensity: null == intensity
          ? _value.intensity
          : intensity // ignore: cast_nullable_to_non_nullable
              as double,
      triggers: null == triggers
          ? _value.triggers
          : triggers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      resolved: null == resolved
          ? _value.resolved
          : resolved // ignore: cast_nullable_to_non_nullable
              as bool,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CravingLogImplCopyWith<$Res>
    implements $CravingLogCopyWith<$Res> {
  factory _$$CravingLogImplCopyWith(
          _$CravingLogImpl value, $Res Function(_$CravingLogImpl) then) =
      __$$CravingLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double intensity,
      List<String> triggers,
      DateTime timestamp,
      bool resolved,
      DateTime? resolvedAt});
}

/// @nodoc
class __$$CravingLogImplCopyWithImpl<$Res>
    extends _$CravingLogCopyWithImpl<$Res, _$CravingLogImpl>
    implements _$$CravingLogImplCopyWith<$Res> {
  __$$CravingLogImplCopyWithImpl(
      _$CravingLogImpl _value, $Res Function(_$CravingLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of CravingLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intensity = null,
    Object? triggers = null,
    Object? timestamp = null,
    Object? resolved = null,
    Object? resolvedAt = freezed,
  }) {
    return _then(_$CravingLogImpl(
      intensity: null == intensity
          ? _value.intensity
          : intensity // ignore: cast_nullable_to_non_nullable
              as double,
      triggers: null == triggers
          ? _value._triggers
          : triggers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      resolved: null == resolved
          ? _value.resolved
          : resolved // ignore: cast_nullable_to_non_nullable
              as bool,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CravingLogImpl implements _CravingLog {
  const _$CravingLogImpl(
      {required this.intensity,
      required final List<String> triggers,
      required this.timestamp,
      this.resolved = false,
      this.resolvedAt})
      : _triggers = triggers;

  factory _$CravingLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$CravingLogImplFromJson(json);

  @override
  final double intensity;
  final List<String> _triggers;
  @override
  List<String> get triggers {
    if (_triggers is EqualUnmodifiableListView) return _triggers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triggers);
  }

  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final bool resolved;
  @override
  final DateTime? resolvedAt;

  @override
  String toString() {
    return 'CravingLog(intensity: $intensity, triggers: $triggers, timestamp: $timestamp, resolved: $resolved, resolvedAt: $resolvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CravingLogImpl &&
            (identical(other.intensity, intensity) ||
                other.intensity == intensity) &&
            const DeepCollectionEquality().equals(other._triggers, _triggers) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.resolved, resolved) ||
                other.resolved == resolved) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      intensity,
      const DeepCollectionEquality().hash(_triggers),
      timestamp,
      resolved,
      resolvedAt);

  /// Create a copy of CravingLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CravingLogImplCopyWith<_$CravingLogImpl> get copyWith =>
      __$$CravingLogImplCopyWithImpl<_$CravingLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CravingLogImplToJson(
      this,
    );
  }
}

abstract class _CravingLog implements CravingLog {
  const factory _CravingLog(
      {required final double intensity,
      required final List<String> triggers,
      required final DateTime timestamp,
      final bool resolved,
      final DateTime? resolvedAt}) = _$CravingLogImpl;

  factory _CravingLog.fromJson(Map<String, dynamic> json) =
      _$CravingLogImpl.fromJson;

  @override
  double get intensity;
  @override
  List<String> get triggers;
  @override
  DateTime get timestamp;
  @override
  bool get resolved;
  @override
  DateTime? get resolvedAt;

  /// Create a copy of CravingLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CravingLogImplCopyWith<_$CravingLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
