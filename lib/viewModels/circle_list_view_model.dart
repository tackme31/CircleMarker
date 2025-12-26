import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/states/circle_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'circle_list_view_model.g.dart';

@riverpod
class CircleListViewModel extends _$CircleListViewModel {
  @override
  Future<CircleListState> build() async {
    final circles = await ref.read(circleRepositoryProvider).getAllCircles();
    return CircleListState(circles: circles);
  }
}
