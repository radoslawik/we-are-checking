class PositionEntry {
    final DateTime time;
    final Map<String, CarPosition> data;

  PositionEntry(this.time, this.data);
}

class CarPosition {
  final String status;
  final int x;
  final int y;
  final int z;

  CarPosition(this.status, this.x, this.y, this.z);
}