import 'package:hard_tyre/models/data/ergast/circuits.dart';
import 'package:hard_tyre/models/data/livetiming/position.dart';
import 'package:hard_tyre/models/media/playground_item.dart';

class LapTime {
  final DateTime when;
  final Duration time;

  LapTime(this.when, this.time);
}

class LapPosition {
  final String driverNumber;
  final LapTime info;
  final Map<Duration, CarPosition?> coords;

  LapPosition(this.driverNumber, this.info, this.coords);
}

class LapPositionComparison extends DetailedPlaygroundItem {
  final List<LapPosition>? lapPositions;
  final Race? race;

  LapPositionComparison({this.lapPositions, this.race});
}

class BestLaps {
  final Race race;
  final Map<String, LapTime> laps;

  BestLaps(this.race, this.laps);
}