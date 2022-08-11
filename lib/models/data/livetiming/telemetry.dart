class TelemetryEntry {
    final DateTime time;
    final Map<String, CarTelemetry> data;

  TelemetryEntry(this.time, this.data);
}

class CarTelemetry {
  final int speed;
  final int rpm;
  final int gear;
  final int throttle;
  final bool brake;
  final bool drs;

  CarTelemetry(this.speed, this.rpm, this.gear, this.throttle, this.brake, this.drs);
}