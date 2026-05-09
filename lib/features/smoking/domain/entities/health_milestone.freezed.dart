// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_milestone.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HealthMilestone {
  String get title => throw _privateConstructorUsedError;
  Duration get timeAfterQuitting => throw _privateConstructorUsedError;
  bool get isAchieved => throw _privateConstructorUsedError;
  DateTime? get achievedAt => throw _privateConstructorUsedError;

  /// Create a copy of HealthMilestone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthMilestoneCopyWith<HealthMilestone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthMilestoneCopyWith<$Res> {
  factory $HealthMilestoneCopyWith(
          HealthMilestone value, $Res Function(HealthMilestone) then) =
      _$HealthMilestoneCopyWithImpl<$Res, HealthMilestone>;
  @useResult
  $Res call(
      {String title,
      Duration timeAfterQuitting,
      bool isAchieved,
      DateTime? achievedAt});
}

/// @nodoc
class _$HealthMilestoneCopyWithImpl<$Res, $Val extends HealthMilestone>
    implements $HealthMilestoneCopyWith<$Res> {
  _$HealthMilestoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthMilestone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? timeAfterQuitting = null,
    Object? isAchieved = null,
    Object? achievedAt = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      timeAfterQuitting: null == timeAfterQuitting
          ? _value.timeAfterQuitting
          : timeAfterQuitting // ignore: cast_nullable_to_non_nullable
              as Duration,
      isAchieved: null == isAchieved
          ? _value.isAchieved
          : isAchieved // ignore: cast_nullable_to_non_nullable
              as bool,
      achievedAt: freezed == achievedAt
          ? _value.achievedAt
          : achievedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthMilestoneImplCopyWith<$Res>
    implements $HealthMilestoneCopyWith<$Res> {
  factory _$$HealthMilestoneImplCopyWith(_$HealthMilestoneImpl value,
          $Res Function(_$HealthMilestoneImpl) then) =
      __$$HealthMilestoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      Duration timeAfterQuitting,
      bool isAchieved,
      DateTime? achievedAt});
}

/// @nodoc
class __$$HealthMilestoneImplCopyWithImpl<$Res>
    extends _$HealthMilestoneCopyWithImpl<$Res, _$HealthMilestoneImpl>
    implements _$$HealthMilestoneImplCopyWith<$Res> {
  __$$HealthMilestoneImplCopyWithImpl(
      _$HealthMilestoneImpl _value, $Res Function(_$HealthMilestoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of HealthMilestone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? timeAfterQuitting = null,
    Object? isAchieved = null,
    Object? achievedAt = freezed,
  }) {
    return _then(_$HealthMilestoneImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      timeAfterQuitting: null == timeAfterQuitting
          ? _value.timeAfterQuitting
          : timeAfterQuitting // ignore: cast_nullable_to_non_nullable
              as Duration,
      isAchieved: null == isAchieved
          ? _value.isAchieved
          : isAchieved // ignore: cast_nullable_to_non_nullable
              as bool,
      achievedAt: freezed == achievedAt
          ? _value.achievedAt
          : achievedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$HealthMilestoneImpl implements _HealthMilestone {
  const _$HealthMilestoneImpl(
      {required this.title,
      required this.timeAfterQuitting,
      this.isAchieved = false,
      this.achievedAt});

  @override
  final String title;
  @override
  final Duration timeAfterQuitting;
  @override
  @JsonKey()
  final bool isAchieved;
  @override
  final DateTime? achievedAt;

  @override
  String toString() {
    return 'HealthMilestone(title: $title, timeAfterQuitting: $timeAfterQuitting, isAchieved: $isAchieved, achievedAt: $achievedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthMilestoneImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.timeAfterQuitting, timeAfterQuitting) ||
                other.timeAfterQuitting == timeAfterQuitting) &&
            (identical(other.isAchieved, isAchieved) ||
                other.isAchieved == isAchieved) &&
            (identical(other.achievedAt, achievedAt) ||
                other.achievedAt == achievedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, title, timeAfterQuitting, isAchieved, achievedAt);

  /// Create a copy of HealthMilestone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthMilestoneImplCopyWith<_$HealthMilestoneImpl> get copyWith =>
      __$$HealthMilestoneImplCopyWithImpl<_$HealthMilestoneImpl>(
          this, _$identity);
}

abstract class _HealthMilestone implements HealthMilestone {
  const factory _HealthMilestone(
      {required final String title,
      required final Duration timeAfterQuitting,
      final bool isAchieved,
      final DateTime? achievedAt}) = _$HealthMilestoneImpl;

  @override
  String get title;
  @override
  Duration get timeAfterQuitting;
  @override
  bool get isAchieved;
  @override
  DateTime? get achievedAt;

  /// Create a copy of HealthMilestone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthMilestoneImplCopyWith<_$HealthMilestoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
