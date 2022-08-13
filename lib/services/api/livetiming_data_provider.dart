import 'dart:convert';
import 'package:hard_tyre/helpers/livetiming_conversion.dart';
import 'package:hard_tyre/models/data/livetiming/lap_time.dart';
import 'package:hard_tyre/models/data/livetiming/position.dart';
import 'package:hard_tyre/models/data/livetiming/telemetry.dart';
import 'package:hard_tyre/models/media/playground_item.dart';
import 'package:hard_tyre/services/cache_provider.dart';

class LivetimingDataProvider {
  // Singleton
  static final LivetimingDataProvider _singleton = LivetimingDataProvider._internal();
  factory LivetimingDataProvider() => _singleton;
  LivetimingDataProvider._internal();

  final _cacheProvider = CacheProvider();
  // TODO make it generic
  static const _baseUrl = 'http://livetiming.formula1.com/static';
  final _raceUrl = '$_baseUrl/2022/2022-07-31_Hungarian_Grand_Prix/2022-07-31_Race';
  final _qualiUrl = '$_baseUrl/2022/2022-07-31_Hungarian_Grand_Prix/2022-07-30_Qualifying';
  final _carData = 'CarData.z.jsonStream';
  final _posData = 'Position.z.jsonStream';
  final _lapTimes = 'TimingStats.jsonStream';
  final _heartbeatData = 'Heartbeat.jsonStream';

  List<TelemetryEntry>? _telemetries;
  List<PositionEntry>? _positions;
  Map<String, LapTime>? _bestLaps;

  Future<List<PlaygroundItem>> getDataPlayground() async {
    return [
      PlaygroundItem("Lap comparison", () async => await getLapPositionComparisons(["63", "20"]))
    ];
  }

  Future<List<TelemetryEntry>> getTelemetries() async => _telemetries ?? await _retrieveTelemetries();

  Future<List<PositionEntry>> getPositions() async => _positions ?? await _retrievePositions();

  Future<Map<String, LapTime>> getPersonalBests() async => _bestLaps ?? await _retrievePersonalBests();

  Future<LapTime?> getPersonalBest(String driverNumber) async =>
      await getPersonalBests().then((dict) => dict.containsKey(driverNumber) ? dict[driverNumber] : null, onError: (v) => null);

  Future<LapPosition?> getPositionsDuringPersonalBest(String driverNumber) async {
    final personalBest = await getPersonalBest(driverNumber);
    if (personalBest != null) {
      final positions = await getPositions().then(
          (value) => value
              .where((element) =>
                  element.time.compareTo(personalBest.when) < 0 && element.time.compareTo(personalBest.when.subtract(personalBest.time)) >= 0)
              .toList(),
          onError: (v) => []);
      Map<Duration, CarPosition?> coords = {};
      for (var element in positions) {
        coords[personalBest.time - (personalBest.when.difference(element.time))] = element.data[driverNumber];
      }
      return LapPosition(driverNumber, personalBest, coords);
    }
    return null;
  }

  Future<LapPositionComparison> getLapPositionComparisons(List<String> driverIds) async {
    List<LapPosition> comps = [];
    for (var driver in driverIds) {
      final lp = await getPositionsDuringPersonalBest(driver);
      if (lp != null) {
        comps.add(lp);
      }
    }
    return LapPositionComparison(comps);
  }

  List<TelemetryEntry> _parseCarDataRow(String row) {
    final rawInput = row.split('"').elementAt(1);
    final jsonString = LivetimingConversion.decodeToString(rawInput);
    List<dynamic> entries = jsonDecode(jsonString)["Entries"];
    List<TelemetryEntry> telemetries = [];
    for (var entry in entries) {
      final time = DateTime.parse(entry["Utc"]);
      Map<String, dynamic> data = entry["Cars"];
      Map<String, CarTelemetry> carTelemetries = {};
      for (var car in data.keys) {
        Map<String, dynamic> carData = data[car]["Channels"];
        carTelemetries[car] = CarTelemetry(carData["2"], carData["0"], carData["3"], carData["4"], carData["5"] > 0, carData["45"] > 1);
      }
      telemetries.add(TelemetryEntry(time, carTelemetries));
    }
    return telemetries;
  }

  List<PositionEntry> _parsePositionDataRow(String row) {
    final rawInput = row.split('"').elementAt(1);
    final jsonString = LivetimingConversion.decodeToString(rawInput);
    List<dynamic> entries = jsonDecode(jsonString)["Position"];
    List<PositionEntry> positions = [];
    for (var entry in entries) {
      final time = DateTime.parse(entry["Timestamp"]);
      Map<String, dynamic> data = entry["Entries"];
      Map<String, CarPosition> carPositions = {};
      for (var car in data.keys) {
        final d = data[car];
        carPositions[car] = CarPosition(d["Status"], d["X"], d["Y"], d["Z"]);
      }
      positions.add(PositionEntry(time, carPositions));
    }
    return positions;
  }

  Future<List<TelemetryEntry>> _retrieveTelemetries() async {
    final file = await _cacheProvider.tryGetFile('$_qualiUrl/$_carData');
    final content = await file?.readAsLines();
    _telemetries = [];
    for (var row in content ?? []) {
      _telemetries!.addAll(_parseCarDataRow(row));
    }
    return _telemetries!;
  }

  Future<List<PositionEntry>> _retrievePositions() async {
    final file = await _cacheProvider.tryGetFile('$_qualiUrl/$_posData');
    final content = await file?.readAsLines();
    _positions = [];
    for (var row in content ?? []) {
      _positions!.addAll(_parsePositionDataRow(row));
    }
    return _positions!;
  }

  Future<Map<String, LapTime>> _retrievePersonalBests() async {
    final file = await _cacheProvider.tryGetFile('$_qualiUrl/$_lapTimes');
    final content = await file?.readAsLines();
    final startTime = await _getSessionStartTime();
    _bestLaps = {};
    if (startTime != null && content != null) {
      for (var row in content.skip(1)) {
        final ts = LivetimingConversion.parseDuration(row.substring(0, 11));
        if (ts != null) {
          Map<String, dynamic> data = jsonDecode(row.substring(12))["Lines"];
          for (var car in data.keys) {
            final time = data[car]["PersonalBestLapTime"]?["Value"];
            if (time is String) {
              final duration = LivetimingConversion.parseDuration(time);
              if (duration != null && (!_bestLaps!.containsKey(car) || _bestLaps![car]!.time.compareTo(duration) > 0)) {
                _bestLaps![car] = LapTime(startTime.add(ts), duration);
              }
            }
          }
        }
      }
    }
    return _bestLaps!;
  }

  Future<DateTime?> _getSessionStartTime() async {
    final heartbeat = await _cacheProvider.tryGetFile('$_qualiUrl/$_heartbeatData');
    if (heartbeat != null) {
      final sessionTiming = await heartbeat.readAsLines().then((value) => value.first);
      final duration = LivetimingConversion.parseDuration(sessionTiming.substring(0, 11));
      final utc = DateTime.tryParse(jsonDecode(sessionTiming.substring(12))["Utc"]);
      return duration != null && utc != null ? utc.subtract(duration) : null;
    }
    return null;
  }
}
