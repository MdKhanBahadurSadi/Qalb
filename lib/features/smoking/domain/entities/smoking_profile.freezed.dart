// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smoking_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SmokingProfile _$SmokingProfileFromJson(Map<String, dynamic> json) {
  return _SmokingProfile.fromJson(json);
}

/// @nodoc
mixin _$SmokingProfile {
  bool get isCurrentSmoker => throw _privateConstructorUsedError;
  int get cigarettesPerDay => throw _privateConstructorUsedError;
  int get yearsSmoked => throw _privateConstructorUsedError;
  DateTime? get quitDate => throw _privateConstructorUsedError;
  bool get isInRecovery => throw _privateConstructorUsedError;
  double get packagePrice => throw _privateConstructorUsedError;

  /// Serializes this SmokingProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SmokingProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmokingProfileCopyWith<SmokingProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmokingProfileCopyWith<$Res> {
  factory $SmokingProfileCopyWith(
          SmokingProfile value, $Res Function(SmokingProfile) then) =
      _$SmokingProfileCopyWithImpl<$Res, SmokingProfile>;
  @useResult
  $Res call(
      {bool isCurrentSmoker,
      int cigarettesPerDay,
      int yearsSmoked,
      DateTime? quitDate,
      bool isInRecovery,
      double packagePrice});
}

/// @nodoc
class _$SmokingProfileCopyWithImpl<$Res, $Val extends SmokingProfile>
    implements $SmokingProfileCopyWith<$Res> {
  _$SmokingProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmokingProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCurrentSmoker = null,
    Object? cigarettesPerDay = null,
    Object? yearsSmoked = null,
    Object? quitDate = freezed,
    Object? isInRecovery = null,
    Object? packagePrice = null,
  }) {
    return _then(_value.copyWith(
      isCurrentSmoker: null == isCurrentSmoker
          ? _value.isCurrentSmoker
          : isCurrentSmoker // ignore: cast_nullable_to_non_nullable
              as bool,
      cigarettesPerDay: null == cigarettesPerDay
          ? _value.cigarettesPerDay
          : cigarettesPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      yearsSmoked: null == yearsSmoked
          ? _value.yearsSmoked
          : yearsSmoked // ignore: cast_nullable_to_non_nullable
              as int,
      quitDate: freezed == quitDate
          ? _value.quitDate
          : quitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isInRecovery: null == isInRecovery
          ? _value.isInRecovery
          : isInRecovery // ignore: cast_nullable_to_non_nullable
              as bool,
      packagePrice: null == packagePrice
          ? _value.packagePrice
          : packagePrice // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SmokingProfileImplCopyWith<$Res>
    implements $SmokingProfileCopyWith<$Res> {
  factory _$$SmokingProfileImplCopyWith(_$SmokingProfileImpl value,
          $Res Function(_$SmokingProfileImpl) then) =
      __$$SmokingProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isCurrentSmoker,
      int cigarettesPerDay,
      int yearsSmoked,
      DateTime? quitDate,
      bool isInRecovery,
      double packagePrice});
}

/// @nodoc
class __$$SmokingProfileImplCopyWithImpl<$Res>
    extends _$SmokingProfileCopyWithImpl<$Res, _$SmokingProfileImpl>
    implements _$$SmokingProfileImplCopyWith<$Res> {
  __$$SmokingProfileImplCopyWithImpl(
      _$SmokingProfileImpl _value, $Res Function(_$SmokingProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of SmokingProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCurrentSmoker = null,
    Object? cigarettesPerDay = null,
    Object? yearsSmoked = null,
    Object? quitDate = freezed,
    Object? isInRecovery = null,
    Object? packagePrice = null,
  }) {
    return _then(_$SmokingProfileImpl(
      isCurrentSmoker: null == isCurrentSmoker
          ? _value.isCurrentSmoker
          : isCurrentSmoker // ignore: cast_nullable_to_non_nullable
              as bool,
      cigarettesPerDay: null == cigarettesPerDay
          ? _value.cigarettesPerDay
          : cigarettesPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      yearsSmoked: null == yearsSmoked
          ? _value.yearsSmoked
          : yearsSmoked // ignore: cast_nullable_to_non_nullable
              as int,
      quitDate: freezed == quitDate
          ? _value.quitDate
          : quitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isInRecovery: null == isInRecovery
          ? _value.isInRecovery
          : isInRecovery // ignore: cast_nullable_to_non_nullable
              as bool,
      packagePrice: null == packagePrice
          ? _value.packagePrice
          : packagePrice // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SmokingProfileImpl implements _SmokingProfile {
  const _$SmokingProfileImpl(
      {this.isCurrentSmoker = false,
      this.cigarettesPerDay = 0,
      this.yearsSmoked = 0,
      this.quitDate,
      this.isInRecovery = false,
      this.packagePrice = 15.0});

  factory _$SmokingProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmokingProfileImplFromJson(json);

  @override
  @JsonKey()
  final bool isCurrentSmoker;
  @override
  @JsonKey()
  final int cigarettesPerDay;
  @override
  @JsonKey()
  final int yearsSmoked;
  @override
  final DateTime? quitDate;
  @override
  @JsonKey()
  final bool isInRecovery;
  @override
  @JsonKey()
  final double packagePrice;

  @override
  String toString() {
    return 'SmokingProfile(isCurrentSmoker: $isCurrentSmoker, cigarettesPerDay: $cigarettesPerDay, yearsSmoked: $yearsSmoked, quitDate: $quitDate, isInRecovery: $isInRecovery, packagePrice: $packagePrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmokingProfileImpl &&
            (identical(other.isCurrentSmoker, isCurrentSmoker) ||
                other.isCurrentSmoker == isCurrentSmoker) &&
            (identical(other.cigarettesPerDay, cigarettesPerDay) ||
                other.cigarettesPerDay == cigarettesPerDay) &&
            (identical(other.yearsSmoked, yearsSmoked) ||
                other.yearsSmoked == yearsSmoked) &&
            (identical(other.quitDate, quitDate) ||
                other.quitDate == quitDate) &&
            (identical(other.isInRecovery, isInRecovery) ||
                other.isInRecovery == isInRecovery) &&
            (identical(other.packagePrice, packagePrice) ||
                other.packagePrice == packagePrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isCurrentSmoker,
      cigarettesPerDay, yearsSmoked, quitDate, isInRecovery, packagePrice);

  /// Create a copy of SmokingProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmokingProfileImplCopyWith<_$SmokingProfileImpl> get copyWith =>
      __$$SmokingProfileImplCopyWithImpl<_$SmokingProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SmokingProfileImplToJson(
      this,
    );
  }
}

abstract class _SmokingProfile implements SmokingProfile {
  const factory _SmokingProfile(
      {final bool isCurrentSmoker,
      final int cigarettesPerDay,
      final int yearsSmoked,
      final DateTime? quitDate,
      final bool isInRecovery,
      final double packagePrice}) = _$SmokingProfileImpl;

  factory _SmokingProfile.fromJson(Map<String, dynamic> json) =
      _$SmokingProfileImpl.fromJson;

  @override
  bool get isCurrentSmoker;
  @override
  int get cigarettesPerDay;
  @override
  int get yearsSmoked;
  @override
  DateTime? get quitDate;
  @override
  bool get isInRecovery;
  @override
  double get packagePrice;

  /// Create a copy of SmokingProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmokingProfileImplCopyWith<_$SmokingProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
