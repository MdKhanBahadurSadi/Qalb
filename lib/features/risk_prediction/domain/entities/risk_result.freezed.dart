// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'risk_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RiskResult _$RiskResultFromJson(Map<String, dynamic> json) {
  return _RiskResult.fromJson(json);
}

/// @nodoc
mixin _$RiskResult {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError; // 0-100
  RiskCategory get category => throw _privateConstructorUsedError;
  List<String> get topRiskFactors => throw _privateConstructorUsedError;
  List<String> get recommendations => throw _privateConstructorUsedError;
  DateTime get calculatedAt => throw _privateConstructorUsedError;

  /// Serializes this RiskResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RiskResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RiskResultCopyWith<RiskResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RiskResultCopyWith<$Res> {
  factory $RiskResultCopyWith(
          RiskResult value, $Res Function(RiskResult) then) =
      _$RiskResultCopyWithImpl<$Res, RiskResult>;
  @useResult
  $Res call(
      {String id,
      String userId,
      int score,
      RiskCategory category,
      List<String> topRiskFactors,
      List<String> recommendations,
      DateTime calculatedAt});
}

/// @nodoc
class _$RiskResultCopyWithImpl<$Res, $Val extends RiskResult>
    implements $RiskResultCopyWith<$Res> {
  _$RiskResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RiskResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? score = null,
    Object? category = null,
    Object? topRiskFactors = null,
    Object? recommendations = null,
    Object? calculatedAt = null,
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
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as RiskCategory,
      topRiskFactors: null == topRiskFactors
          ? _value.topRiskFactors
          : topRiskFactors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      calculatedAt: null == calculatedAt
          ? _value.calculatedAt
          : calculatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RiskResultImplCopyWith<$Res>
    implements $RiskResultCopyWith<$Res> {
  factory _$$RiskResultImplCopyWith(
          _$RiskResultImpl value, $Res Function(_$RiskResultImpl) then) =
      __$$RiskResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      int score,
      RiskCategory category,
      List<String> topRiskFactors,
      List<String> recommendations,
      DateTime calculatedAt});
}

/// @nodoc
class __$$RiskResultImplCopyWithImpl<$Res>
    extends _$RiskResultCopyWithImpl<$Res, _$RiskResultImpl>
    implements _$$RiskResultImplCopyWith<$Res> {
  __$$RiskResultImplCopyWithImpl(
      _$RiskResultImpl _value, $Res Function(_$RiskResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of RiskResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? score = null,
    Object? category = null,
    Object? topRiskFactors = null,
    Object? recommendations = null,
    Object? calculatedAt = null,
  }) {
    return _then(_$RiskResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as RiskCategory,
      topRiskFactors: null == topRiskFactors
          ? _value._topRiskFactors
          : topRiskFactors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      calculatedAt: null == calculatedAt
          ? _value.calculatedAt
          : calculatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RiskResultImpl implements _RiskResult {
  const _$RiskResultImpl(
      {required this.id,
      required this.userId,
      required this.score,
      required this.category,
      required final List<String> topRiskFactors,
      required final List<String> recommendations,
      required this.calculatedAt})
      : _topRiskFactors = topRiskFactors,
        _recommendations = recommendations;

  factory _$RiskResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$RiskResultImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final int score;
// 0-100
  @override
  final RiskCategory category;
  final List<String> _topRiskFactors;
  @override
  List<String> get topRiskFactors {
    if (_topRiskFactors is EqualUnmodifiableListView) return _topRiskFactors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topRiskFactors);
  }

  final List<String> _recommendations;
  @override
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  final DateTime calculatedAt;

  @override
  String toString() {
    return 'RiskResult(id: $id, userId: $userId, score: $score, category: $category, topRiskFactors: $topRiskFactors, recommendations: $recommendations, calculatedAt: $calculatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RiskResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality()
                .equals(other._topRiskFactors, _topRiskFactors) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            (identical(other.calculatedAt, calculatedAt) ||
                other.calculatedAt == calculatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      score,
      category,
      const DeepCollectionEquality().hash(_topRiskFactors),
      const DeepCollectionEquality().hash(_recommendations),
      calculatedAt);

  /// Create a copy of RiskResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RiskResultImplCopyWith<_$RiskResultImpl> get copyWith =>
      __$$RiskResultImplCopyWithImpl<_$RiskResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RiskResultImplToJson(
      this,
    );
  }
}

abstract class _RiskResult implements RiskResult {
  const factory _RiskResult(
      {required final String id,
      required final String userId,
      required final int score,
      required final RiskCategory category,
      required final List<String> topRiskFactors,
      required final List<String> recommendations,
      required final DateTime calculatedAt}) = _$RiskResultImpl;

  factory _RiskResult.fromJson(Map<String, dynamic> json) =
      _$RiskResultImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  int get score; // 0-100
  @override
  RiskCategory get category;
  @override
  List<String> get topRiskFactors;
  @override
  List<String> get recommendations;
  @override
  DateTime get calculatedAt;

  /// Create a copy of RiskResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RiskResultImplCopyWith<_$RiskResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
