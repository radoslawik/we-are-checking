import 'package:hard_tyre/models/data/livetiming/position.dart';
import 'package:hard_tyre/models/media/playground_item.dart';

class LapTime {
  final DateTime when;
  final Duration time;

  LapTime(this.when, this.time);
}

class LapPosition {
  final String driverNumber;
  final DateTime time;
  final CarPosition position;

  LapPosition(this.driverNumber, this.time, this.position);
}

class LapPositionComparison extends DetailedPlaygroundItem {
  final Map<String, List<LapPosition>> items;

  LapPositionComparison(this.items);
}