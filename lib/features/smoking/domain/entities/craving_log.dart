import 'package:freezed_annotation/freezed_annotation.dart';

part 'craving_log.freezed.dart';
part 'craving_log.g.dart';

@freezed
class CravingLog with _$CravingLog {
  const factory CravingLog({
    required double intensity,
    required List<String> triggers,
    required DateTime timestamp,
    @Default(false) bool resolved,
    DateTime? resolvedAt,
  }) = _CravingLog;

  factory CravingLog.fromJson(Map<String, dynamic> json) => _$CravingLogFromJson(json);
}
