import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:hard_tyre/helpers/livetiming_conversion.dart';
import 'package:hard_tyre/models/data/ergast/circuits.dart';
import 'package:hard_tyre/models/data/livetiming/lap_time.dart';
import 'package:hard_tyre/models/data/livetiming/position.dart';
import 'package:hard_tyre/models/data/livetiming/telemetry.dart';
import 'package:hard_tyre/models/media/playground_item.dart';
import 'package:hard_tyre/services/api/ergast_data_provider.dart';
import 'package:hard_tyre/services/cache_provider.dart';

class LivetimingDataProvider {
  // Singleton
  static final LivetimingDataProvider _singleton = LivetimingDataProvider._internal();
  factory LivetimingDataProvider() => _singleton;
  LivetimingDataProvider._internal();

  final _cacheProvider = CacheProvider();
  final _ergast = ErgastDataProvider();
  // TODO make it generic
  static const _baseUrl = 'http://livetiming.formula1.com/static';
  //final _raceUrl = '$_baseUrl/2022/2022-07-31_Hungarian_Grand_Prix/2022-07-31_Race';
  //final _qualiUrl = '$_baseUrl/2022/2022-07-31_Hungarian_Grand_Prix/2022-07-30_Qualifying';
  final _carData = 'CarData.z.jsonStream';
  final _posData = 'Position.z.jsonStream';
  final _lapTimes = 'TimingStats.jsonStream';
  final _heartbeatData = 'Heartbeat.jsonStream';

  final Map<String, List<TelemetryEntry>> _qualiTelemetries = {};
  final Map<String, List<PositionEntry>> _qualiPositions = {};
  final List<BestLaps> _bestLaps = [];

  Future<List<PlaygroundItem>> getDataPlayground() async {
    return [PlaygroundItem("Lap comparison", () async => await getLapPositionComparisons([], null))];
  }

  Future<List<TelemetryEntry>> getTelemetries(Race race, {bool quali = true}) async =>
    _qualiTelemetries[race.raceName] ?? await _retrieveTelemetries(race, quali: quali);

  Future<List<PositionEntry>> getPositions(Race race, {bool quali = true}) async =>
    _qualiPositions[race.raceName] ?? await _retrievePositions(race, quali: quali);

  Future<BestLaps> getPersonalBests(Race race, {bool quali = true}) async =>
      _bestLaps.firstWhereOrNull((b) => b.race.raceName == race.raceName) ?? await _retrievePersonalBests(race, quali: quali);

  Future<LapTime?> getPersonalBest(String driverNumber, Race race, {bool quali = true}) async =>
      await getPersonalBests(race).then((bl) => bl.laps.containsKey(driverNumber) ? bl.laps[driverNumber] : null, onError: (v) => null);

  Future<LapPosition?> getPositionsDuringPersonalBest(String driverNumber, Race race, {bool quali = true}) async {
    final personalBest = await getPersonalBest(driverNumber, race, quali: quali);
    if (personalBest != null) {
      final positions = await getPositions(race, quali: quali).then(
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

  Future<LapPositionComparison> getLapPositionComparisons(List<String>? driverIds, Race? race) async {
    if (driverIds == null || race == null) {
      return LapPositionComparison();
    }

    List<LapPosition> comps = [];
    for (var driver in driverIds) {
      final lp = await getPositionsDuringPersonalBest(driver, race);
      if (lp != null) {
        comps.add(lp);
      }
    }
    return LapPositionComparison(lapPositions: comps, race: race);
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

  Future<List<TelemetryEntry>> _retrieveTelemetries(Race race, {bool quali = true}) async {
    final url = '$_baseUrl/2022/${_getRaceUrl(race, quali: quali)}/$_carData';
    final file = await _cacheProvider.tryGetFile(url);
    final content = await file?.readAsLines();
    List<TelemetryEntry> telemetries = [];
    for (var row in content ?? []) {
      telemetries.addAll(_parseCarDataRow(row));
    }
    _qualiTelemetries[race.raceName] = telemetries;
    return telemetries;
  }

  Future<List<PositionEntry>> _retrievePositions(Race race, {bool quali = true}) async {
    final url = '$_baseUrl/2022/${_getRaceUrl(race, quali: quali)}/$_posData';
    final file = await _cacheProvider.tryGetFile(url);
    final content = await file?.readAsLines();
    List<PositionEntry> positions = [];
    for (var row in content ?? []) {
      positions.addAll(_parsePositionDataRow(row));
    }
    _qualiPositions[race.raceName] = positions;
    return positions;
  }

  Future<BestLaps> _retrievePersonalBests(Race race, {bool quali = true}) async {
    final url = '$_baseUrl/2022/${_getRaceUrl(race)}/$_lapTimes';
    final file = await _cacheProvider.tryGetFile(url);
    final content = await file?.readAsLines();
    final startTime = await _getSessionStartTime(race);
    Map<String, LapTime> bLaps = {};
    if (startTime != null && content != null) {
      for (var row in content.skip(1)) {
        final ts = LivetimingConversion.parseDuration(row.substring(0, 11));
        if (ts != null) {
          Map<String, dynamic> data = jsonDecode(row.substring(12))["Lines"];
          for (var car in data.keys) {
            final time = data[car]["PersonalBestLapTime"]?["Value"];
            if (time is String) {
              final duration = LivetimingConversion.parseDuration(time);
              if (duration != null && (!bLaps.containsKey(car) || bLaps[car]!.time.compareTo(duration) > 0)) {
                bLaps[car] = LapTime(startTime.add(ts), duration);
              }
            }
          }
        }
      }
    }
    final bestLaps = BestLaps(race, bLaps);
    _bestLaps.add(bestLaps);
    return bestLaps;
  }

  Future<DateTime?> _getSessionStartTime(Race race, {bool quali = true}) async {
    final url = '$_baseUrl/2022/${_getRaceUrl(race, quali: quali)}/$_heartbeatData';
    final heartbeat = await _cacheProvider.tryGetFile(url);
    if (heartbeat != null) {
      final sessionTiming = await heartbeat.readAsLines().then((value) => value.first);
      final duration = LivetimingConversion.parseDuration(sessionTiming.substring(0, 11));
      final utc = DateTime.tryParse(jsonDecode(sessionTiming.substring(12))["Utc"]);
      return duration != null && utc != null ? utc.subtract(duration) : null;
    }
    return null;
  }

  String _getRaceUrl(Race race, {bool quali = true}) {
    // 2022-07-31_Hungarian_Grand_Prix/2022-07-30_Qualifying
    final raceDate = DateFormat('yyyy-MM-dd').format(race.date);
    final raceName = race.raceName.replaceAll(RegExp(r' '), '_');
    if (quali) {
      final qualiDate = DateFormat('yyyy-MM-dd').format(race.qualifying.date);
      return '${raceDate}_$raceName/${qualiDate}_Qualifying';
    }
    return '${raceDate}_$raceName/${raceDate}_Race';
  }
}
