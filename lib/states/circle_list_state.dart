import 'package:circle_marker/models/circle_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_list_state.freezed.dart';

@freezed
class CircleListState with _$CircleListState {
  const factory CircleListState({
    @Default([]) List<CircleDetail> circles,
  }) = _CircleListState;
}
