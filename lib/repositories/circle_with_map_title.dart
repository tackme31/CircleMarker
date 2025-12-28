import 'package:circle_marker/models/circle_detail.dart';

class CircleWithMapTitle {
  CircleWithMapTitle({
    required this.circle,
    required this.mapTitle,
    required this.eventName,
  });
  final CircleDetail circle;
  final String? mapTitle;
  final String? eventName;
}
