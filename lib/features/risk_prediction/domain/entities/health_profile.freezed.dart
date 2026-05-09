// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HealthProfile _$HealthProfileFromJson(Map<String, dynamic> json) {
  return _HealthProfile.fromJson(json);
}

/// @nodoc
mixin _$HealthProfile {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  String get sex => throw _privateConstructorUsedError; // 'Male' / 'Female'
  int get cholesterol => throw _privateConstructorUsedError; // mg/dL
  int get systolicBP => throw _privateConstructorUsedError;
  int get diastolicBP => throw _privateConstructorUsedError;
  int get heartRate => throw _privateConstructorUsedError; // bpm
  bool get diabetes => throw _privateConstructorUsedError;
  bool get familyHistory => throw _privateConstructorUsedError;
  bool get smoking => throw _privateConstructorUsedError;
  bool get obesity => throw _privateConstructorUsedError;
  bool get alcoholConsumption => throw _privateConstructorUsedError;
  double get exerciseHoursPerWeek => throw _privateConstructorUsedError;
  String get diet =>
      throw _privateConstructorUsedError; // 'Healthy' / 'Average' / 'Unhealthy'
  bool get previousHeartProblems => throw _privateConstructorUsedError;
  bool get medicationUse => throw _privateConstructorUsedError;
  int get stressLevel => throw _privateConstructorUsedError; // 1-10
  double get sedentaryHoursPerDay => throw _privateConstructorUsedError;
  double get bmi => throw _privateConstructorUsedError;
  int get triglycerides => throw _privateConstructorUsedError;
  int get physicalActivityDaysPerWeek => throw _privateConstructorUsedError;
  int get sleepHoursPerDay => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this HealthProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthProfileCopyWith<HealthProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthProfileCopyWith<$Res> {
  factory $HealthProfileCopyWith(
          HealthProfile value, $Res Function(HealthProfile) then) =
      _$HealthProfileCopyWithImpl<$Res, HealthProfile>;
  @useResult
  $Res call(
      {String id,
      String userId,
      int age,
      String sex,
      int cholesterol,
      int systolicBP,
      int diastolicBP,
      int heartRate,
      bool diabetes,
      bool familyHistory,
      bool smoking,
      bool obesity,
      bool alcoholConsumption,
      double exerciseHoursPerWeek,
      String diet,
      bool previousHeartProblems,
      bool medicationUse,
      int stressLevel,
      double sedentaryHoursPerDay,
      double bmi,
      int triglycerides,
      int physicalActivityDaysPerWeek,
      int sleepHoursPerDay,
      DateTime createdAt});
}

/// @nodoc
class _$HealthProfileCopyWithImpl<$Res, $Val extends HealthProfile>
    implements $HealthProfileCopyWith<$Res> {
  _$HealthProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? age = null,
    Object? sex = null,
    Object? cholesterol = null,
    Object? systolicBP = null,
    Object? diastolicBP = null,
    Object? heartRate = null,
    Object? diabetes = null,
    Object? familyHistory = null,
    Object? smoking = null,
    Object? obesity = null,
    Object? alcoholConsumption = null,
    Object? exerciseHoursPerWeek = null,
    Object? diet = null,
    Object? previousHeartProblems = null,
    Object? medicationUse = null,
    Object? stressLevel = null,
    Object? sedentaryHoursPerDay = null,
    Object? bmi = null,
    Object? triglycerides = null,
    Object? physicalActivityDaysPerWeek = null,
    Object? sleepHoursPerDay = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      sex: null == sex
          ? _value.sex
          : sex // ignore: cast_nullable_to_non_nullable
              as String,
      cholesterol: null == cholesterol
          ? _value.cholesterol
          : cholesterol // ignore: cast_nullable_to_non_nullable
              as int,
      systolicBP: null == systolicBP
          ? _value.systolicBP
          : systolicBP // ignore: cast_nullable_to_non_nullable
              as int,
      diastolicBP: null == diastolicBP
          ? _value.diastolicBP
          : diastolicBP // ignore: cast_nullable_to_non_nullable
              as int,
      heartRate: null == heartRate
          ? _value.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as int,
      diabetes: null == diabetes
          ? _value.diabetes
          : diabetes // ignore: cast_nullable_to_non_nullable
              as bool,
      familyHistory: null == familyHistory
          ? _value.familyHistory
          : familyHistory // ignore: cast_nullable_to_non_nullable
              as bool,
      smoking: null == smoking
          ? _value.smoking
          : smoking // ignore: cast_nullable_to_non_nullable
              as bool,
      obesity: null == obesity
          ? _value.obesity
          : obesity // ignore: cast_nullable_to_non_nullable
              as bool,
      alcoholConsumption: null == alcoholConsumption
          ? _value.alcoholConsumption
          : alcoholConsumption // ignore: cast_nullable_to_non_nullable
              as bool,
      exerciseHoursPerWeek: null == exerciseHoursPerWeek
          ? _value.exerciseHoursPerWeek
          : exerciseHoursPerWeek // ignore: cast_nullable_to_non_nullable
              as double,
      diet: null == diet
          ? _value.diet
          : diet // ignore: cast_nullable_to_non_nullable
              as String,
      previousHeartProblems: null == previousHeartProblems
          ? _value.previousHeartProblems
          : previousHeartProblems // ignore: cast_nullable_to_non_nullable
              as bool,
      medicationUse: null == medicationUse
          ? _value.medicationUse
          : medicationUse // ignore: cast_nullable_to_non_nullable
              as bool,
      stressLevel: null == stressLevel
          ? _value.stressLevel
          : stressLevel // ignore: cast_nullable_to_non_nullable
              as int,
      sedentaryHoursPerDay: null == sedentaryHoursPerDay
          ? _value.sedentaryHoursPerDay
          : sedentaryHoursPerDay // ignore: cast_nullable_to_non_nullable
              as double,
      bmi: null == bmi
          ? _value.bmi
          : bmi // ignore: cast_nullable_to_non_nullable
              as double,
      triglycerides: null == triglycerides
          ? _value.triglycerides
          : triglycerides // ignore: cast_nullable_to_non_nullable
              as int,
      physicalActivityDaysPerWeek: null == physicalActivityDaysPerWeek
          ? _value.physicalActivityDaysPerWeek
          : physicalActivityDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      sleepHoursPerDay: null == sleepHoursPerDay
          ? _value.sleepHoursPerDay
          : sleepHoursPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthProfileImplCopyWith<$Res>
    implements $HealthProfileCopyWith<$Res> {
  factory _$$HealthProfileImplCopyWith(
          _$HealthProfileImpl value, $Res Function(_$HealthProfileImpl) then) =
      __$$HealthProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      int age,
      String sex,
      int cholesterol,
      int systolicBP,
      int diastolicBP,
      int heartRate,
      bool diabetes,
      bool familyHistory,
      bool smoking,
      bool obesity,
      bool alcoholConsumption,
      double exerciseHoursPerWeek,
      String diet,
      bool previousHeartProblems,
      bool medicationUse,
      int stressLevel,
      double sedentaryHoursPerDay,
      double bmi,
      int triglycerides,
      int physicalActivityDaysPerWeek,
      int sleepHoursPerDay,
      DateTime createdAt});
}

/// @nodoc
class __$$HealthProfileImplCopyWithImpl<$Res>
    extends _$HealthProfileCopyWithImpl<$Res, _$HealthProfileImpl>
    implements _$$HealthProfileImplCopyWith<$Res> {
  __$$HealthProfileImplCopyWithImpl(
      _$HealthProfileImpl _value, $Res Function(_$HealthProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of HealthProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? age = null,
    Object? sex = null,
    Object? cholesterol = null,
    Object? systolicBP = null,
    Object? diastolicBP = null,
    Object? heartRate = null,
    Object? diabetes = null,
    Object? familyHistory = null,
    Object? smoking = null,
    Object? obesity = null,
    Object? alcoholConsumption = null,
    Object? exerciseHoursPerWeek = null,
    Object? diet = null,
    Object? previousHeartProblems = null,
    Object? medicationUse = null,
    Object? stressLevel = null,
    Object? sedentaryHoursPerDay = null,
    Object? bmi = null,
    Object? triglycerides = null,
    Object? physicalActivityDaysPerWeek = null,
    Object? sleepHoursPerDay = null,
    Object? createdAt = null,
  }) {
    return _then(_$HealthProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      sex: null == sex
          ? _value.sex
          : sex // ignore: cast_nullable_to_non_nullable
              as String,
      cholesterol: null == cholesterol
          ? _value.cholesterol
          : cholesterol // ignore: cast_nullable_to_non_nullable
              as int,
      systolicBP: null == systolicBP
          ? _value.systolicBP
          : systolicBP // ignore: cast_nullable_to_non_nullable
              as int,
      diastolicBP: null == diastolicBP
          ? _value.diastolicBP
          : diastolicBP // ignore: cast_nullable_to_non_nullable
              as int,
      heartRate: null == heartRate
          ? _value.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as int,
      diabetes: null == diabetes
          ? _value.diabetes
          : diabetes // ignore: cast_nullable_to_non_nullable
              as bool,
      familyHistory: null == familyHistory
          ? _value.familyHistory
          : familyHistory // ignore: cast_nullable_to_non_nullable
              as bool,
      smoking: null == smoking
          ? _value.smoking
          : smoking // ignore: cast_nullable_to_non_nullable
              as bool,
      obesity: null == obesity
          ? _value.obesity
          : obesity // ignore: cast_nullable_to_non_nullable
              as bool,
      alcoholConsumption: null == alcoholConsumption
          ? _value.alcoholConsumption
          : alcoholConsumption // ignore: cast_nullable_to_non_nullable
              as bool,
      exerciseHoursPerWeek: null == exerciseHoursPerWeek
          ? _value.exerciseHoursPerWeek
          : exerciseHoursPerWeek // ignore: cast_nullable_to_non_nullable
              as double,
      diet: null == diet
          ? _value.diet
          : diet // ignore: cast_nullable_to_non_nullable
              as String,
      previousHeartProblems: null == previousHeartProblems
          ? _value.previousHeartProblems
          : previousHeartProblems // ignore: cast_nullable_to_non_nullable
              as bool,
      medicationUse: null == medicationUse
          ? _value.medicationUse
          : medicationUse // ignore: cast_nullable_to_non_nullable
              as bool,
      stressLevel: null == stressLevel
          ? _value.stressLevel
          : stressLevel // ignore: cast_nullable_to_non_nullable
              as int,
      sedentaryHoursPerDay: null == sedentaryHoursPerDay
          ? _value.sedentaryHoursPerDay
          : sedentaryHoursPerDay // ignore: cast_nullable_to_non_nullable
              as double,
      bmi: null == bmi
          ? _value.bmi
          : bmi // ignore: cast_nullable_to_non_nullable
              as double,
      triglycerides: null == triglycerides
          ? _value.triglycerides
          : triglycerides // ignore: cast_nullable_to_non_nullable
              as int,
      physicalActivityDaysPerWeek: null == physicalActivityDaysPerWeek
          ? _value.physicalActivityDaysPerWeek
          : physicalActivityDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      sleepHoursPerDay: null == sleepHoursPerDay
          ? _value.sleepHoursPerDay
          : sleepHoursPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthProfileImpl implements _HealthProfile {
  const _$HealthProfileImpl(
      {required this.id,
      required this.userId,
      required this.age,
      required this.sex,
      required this.cholesterol,
      required this.systolicBP,
      required this.diastolicBP,
      required this.heartRate,
      required this.diabetes,
      required this.familyHistory,
      required this.smoking,
      required this.obesity,
      required this.alcoholConsumption,
      required this.exerciseHoursPerWeek,
      required this.diet,
      required this.previousHeartProblems,
      required this.medicationUse,
      required this.stressLevel,
      required this.sedentaryHoursPerDay,
      required this.bmi,
      required this.triglycerides,
      required this.physicalActivityDaysPerWeek,
      required this.sleepHoursPerDay,
      required this.createdAt});

  factory _$HealthProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final int age;
  @override
  final String sex;
// 'Male' / 'Female'
  @override
  final int cholesterol;
// mg/dL
  @override
  final int systolicBP;
  @override
  final int diastolicBP;
  @override
  final int heartRate;
// bpm
  @override
  final bool diabetes;
  @override
  final bool familyHistory;
  @override
  final bool smoking;
  @override
  final bool obesity;
  @override
  final bool alcoholConsumption;
  @override
  final double exerciseHoursPerWeek;
  @override
  final String diet;
// 'Healthy' / 'Average' / 'Unhealthy'
  @override
  final bool previousHeartProblems;
  @override
  final bool medicationUse;
  @override
  final int stressLevel;
// 1-10
  @override
  final double sedentaryHoursPerDay;
  @override
  final double bmi;
  @override
  final int triglycerides;
  @override
  final int physicalActivityDaysPerWeek;
  @override
  final int sleepHoursPerDay;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'HealthProfile(id: $id, userId: $userId, age: $age, sex: $sex, cholesterol: $cholesterol, systolicBP: $systolicBP, diastolicBP: $diastolicBP, heartRate: $heartRate, diabetes: $diabetes, familyHistory: $familyHistory, smoking: $smoking, obesity: $obesity, alcoholConsumption: $alcoholConsumption, exerciseHoursPerWeek: $exerciseHoursPerWeek, diet: $diet, previousHeartProblems: $previousHeartProblems, medicationUse: $medicationUse, stressLevel: $stressLevel, sedentaryHoursPerDay: $sedentaryHoursPerDay, bmi: $bmi, triglycerides: $triglycerides, physicalActivityDaysPerWeek: $physicalActivityDaysPerWeek, sleepHoursPerDay: $sleepHoursPerDay, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.sex, sex) || other.sex == sex) &&
            (identical(other.cholesterol, cholesterol) ||
                other.cholesterol == cholesterol) &&
            (identical(other.systolicBP, systolicBP) ||
                other.systolicBP == systolicBP) &&
            (identical(other.diastolicBP, diastolicBP) ||
                other.diastolicBP == diastolicBP) &&
            (identical(other.heartRate, heartRate) ||
                other.heartRate == heartRate) &&
            (identical(other.diabetes, diabetes) ||
                other.diabetes == diabetes) &&
            (identical(other.familyHistory, familyHistory) ||
                other.familyHistory == familyHistory) &&
            (identical(other.smoking, smoking) || other.smoking == smoking) &&
            (identical(other.obesity, obesity) || other.obesity == obesity) &&
            (identical(other.alcoholConsumption, alcoholConsumption) ||
                other.alcoholConsumption == alcoholConsumption) &&
            (identical(other.exerciseHoursPerWeek, exerciseHoursPerWeek) ||
                other.exerciseHoursPerWeek == exerciseHoursPerWeek) &&
            (identical(other.diet, diet) || other.diet == diet) &&
            (identical(other.previousHeartProblems, previousHeartProblems) ||
                other.previousHeartProblems == previousHeartProblems) &&
            (identical(other.medicationUse, medicationUse) ||
                other.medicationUse == medicationUse) &&
            (identical(other.stressLevel, stressLevel) ||
                other.stressLevel == stressLevel) &&
            (identical(other.sedentaryHoursPerDay, sedentaryHoursPerDay) ||
                other.sedentaryHoursPerDay == sedentaryHoursPerDay) &&
            (identical(other.bmi, bmi) || other.bmi == bmi) &&
            (identical(other.triglycerides, triglycerides) ||
                other.triglycerides == triglycerides) &&
            (identical(other.physicalActivityDaysPerWeek,
                    physicalActivityDaysPerWeek) ||
                other.physicalActivityDaysPerWeek ==
                    physicalActivityDaysPerWeek) &&
            (identical(other.sleepHoursPerDay, sleepHoursPerDay) ||
                other.sleepHoursPerDay == sleepHoursPerDay) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        age,
        sex,
        cholesterol,
        systolicBP,
        diastolicBP,
        heartRate,
        diabetes,
        familyHistory,
        smoking,
        obesity,
        alcoholConsumption,
        exerciseHoursPerWeek,
        diet,
        previousHeartProblems,
        medicationUse,
        stressLevel,
        sedentaryHoursPerDay,
        bmi,
        triglycerides,
        physicalActivityDaysPerWeek,
        sleepHoursPerDay,
        createdAt
      ]);

  /// Create a copy of HealthProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthProfileImplCopyWith<_$HealthProfileImpl> get copyWith =>
      __$$HealthProfileImplCopyWithImpl<_$HealthProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthProfileImplToJson(
      this,
    );
  }
}

abstract class _HealthProfile implements HealthProfile {
  const factory _HealthProfile(
      {required final String id,
      required final String userId,
      required final int age,
      required final String sex,
      required final int cholesterol,
      required final int systolicBP,
      required final int diastolicBP,
      required final int heartRate,
      required final bool diabetes,
      required final bool familyHistory,
      required final bool smoking,
      required final bool obesity,
      required final bool alcoholConsumption,
      required final double exerciseHoursPerWeek,
      required final String diet,
      required final bool previousHeartProblems,
      required final bool medicationUse,
      required final int stressLevel,
      required final double sedentaryHoursPerDay,
      required final double bmi,
      required final int triglycerides,
      required final int physicalActivityDaysPerWeek,
      required final int sleepHoursPerDay,
      required final DateTime createdAt}) = _$HealthProfileImpl;

  factory _HealthProfile.fromJson(Map<String, dynamic> json) =
      _$HealthProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  int get age;
  @override
  String get sex; // 'Male' / 'Female'
  @override
  int get cholesterol; // mg/dL
  @override
  int get systolicBP;
  @override
  int get diastolicBP;
  @override
  int get heartRate; // bpm
  @override
  bool get diabetes;
  @override
  bool get familyHistory;
  @override
  bool get smoking;
  @override
  bool get obesity;
  @override
  bool get alcoholConsumption;
  @override
  double get exerciseHoursPerWeek;
  @override
  String get diet; // 'Healthy' / 'Average' / 'Unhealthy'
  @override
  bool get previousHeartProblems;
  @override
  bool get medicationUse;
  @override
  int get stressLevel; // 1-10
  @override
  double get sedentaryHoursPerDay;
  @override
  double get bmi;
  @override
  int get triglycerides;
  @override
  int get physicalActivityDaysPerWeek;
  @override
  int get sleepHoursPerDay;
  @override
  DateTime get createdAt;

  /// Create a copy of HealthProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthProfileImplCopyWith<_$HealthProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
