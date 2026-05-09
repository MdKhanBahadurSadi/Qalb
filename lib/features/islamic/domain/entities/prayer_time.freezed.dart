// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer_time.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PrayerTime {
  String get name => throw _privateConstructorUsedError;
  String get arabicName => throw _privateConstructorUsedError;
  DateTime get time => throw _privateConstructorUsedError;
  bool get isNext => throw _privateConstructorUsedError;
  bool get isPassed => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;

  /// Create a copy of PrayerTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrayerTimeCopyWith<PrayerTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrayerTimeCopyWith<$Res> {
  factory $PrayerTimeCopyWith(
          PrayerTime value, $Res Function(PrayerTime) then) =
      _$PrayerTimeCopyWithImpl<$Res, PrayerTime>;
  @useResult
  $Res call(
      {String name,
      String arabicName,
      DateTime time,
      bool isNext,
      bool isPassed,
      String icon});
}

/// @nodoc
class _$PrayerTimeCopyWithImpl<$Res, $Val extends PrayerTime>
    implements $PrayerTimeCopyWith<$Res> {
  _$PrayerTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrayerTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? arabicName = null,
    Object? time = null,
    Object? isNext = null,
    Object? isPassed = null,
    Object? icon = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      arabicName: null == arabicName
          ? _value.arabicName
          : arabicName // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isNext: null == isNext
          ? _value.isNext
          : isNext // ignore: cast_nullable_to_non_nullable
              as bool,
      isPassed: null == isPassed
          ? _value.isPassed
          : isPassed // ignore: cast_nullable_to_non_nullable
              as bool,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrayerTimeImplCopyWith<$Res>
    implements $PrayerTimeCopyWith<$Res> {
  factory _$$PrayerTimeImplCopyWith(
          _$PrayerTimeImpl value, $Res Function(_$PrayerTimeImpl) then) =
      __$$PrayerTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String arabicName,
      DateTime time,
      bool isNext,
      bool isPassed,
      String icon});
}

/// @nodoc
class __$$PrayerTimeImplCopyWithImpl<$Res>
    extends _$PrayerTimeCopyWithImpl<$Res, _$PrayerTimeImpl>
    implements _$$PrayerTimeImplCopyWith<$Res> {
  __$$PrayerTimeImplCopyWithImpl(
      _$PrayerTimeImpl _value, $Res Function(_$PrayerTimeImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrayerTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? arabicName = null,
    Object? time = null,
    Object? isNext = null,
    Object? isPassed = null,
    Object? icon = null,
  }) {
    return _then(_$PrayerTimeImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      arabicName: null == arabicName
          ? _value.arabicName
          : arabicName // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isNext: null == isNext
          ? _value.isNext
          : isNext // ignore: cast_nullable_to_non_nullable
              as bool,
      isPassed: null == isPassed
          ? _value.isPassed
          : isPassed // ignore: cast_nullable_to_non_nullable
              as bool,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PrayerTimeImpl implements _PrayerTime {
  const _$PrayerTimeImpl(
      {required this.name,
      required this.arabicName,
      required this.time,
      required this.isNext,
      required this.isPassed,
      required this.icon});

  @override
  final String name;
  @override
  final String arabicName;
  @override
  final DateTime time;
  @override
  final bool isNext;
  @override
  final bool isPassed;
  @override
  final String icon;

  @override
  String toString() {
    return 'PrayerTime(name: $name, arabicName: $arabicName, time: $time, isNext: $isNext, isPassed: $isPassed, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerTimeImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.arabicName, arabicName) ||
                other.arabicName == arabicName) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.isNext, isNext) || other.isNext == isNext) &&
            (identical(other.isPassed, isPassed) ||
                other.isPassed == isPassed) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, name, arabicName, time, isNext, isPassed, icon);

  /// Create a copy of PrayerTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerTimeImplCopyWith<_$PrayerTimeImpl> get copyWith =>
      __$$PrayerTimeImplCopyWithImpl<_$PrayerTimeImpl>(this, _$identity);
}

abstract class _PrayerTime implements PrayerTime {
  const factory _PrayerTime(
      {required final String name,
      required final String arabicName,
      required final DateTime time,
      required final bool isNext,
      required final bool isPassed,
      required final String icon}) = _$PrayerTimeImpl;

  @override
  String get name;
  @override
  String get arabicName;
  @override
  DateTime get time;
  @override
  bool get isNext;
  @override
  bool get isPassed;
  @override
  String get icon;

  /// Create a copy of PrayerTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerTimeImplCopyWith<_$PrayerTimeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
