import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_summary.freezed.dart';
part 'map_summary.g.dart';

@freezed
class MapSummary with _$MapSummary {
  factory MapSummary({int? mapId, String? title}) = _MapSummary;

  factory MapSummary.fromJson(Map<String, dynamic> json) =>
      _$MapSummaryFromJson(json);
}
