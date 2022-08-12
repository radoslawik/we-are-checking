import 'dart:convert';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hard_tyre/helpers/livetiming_conversion.dart';
import 'package:hard_tyre/models/data/livetiming/lap_time.dart';
import 'package:hard_tyre/models/data/livetiming/position.dart';
import 'package:hard_tyre/models/data/livetiming/telemetry.dart';

class LivetimingDataProvider {
  final _cacheManager = DefaultCacheManager();
  static const _baseUrl = 'http://livetiming.formula1.com/static';
  final _raceUrl = '$_baseUrl/2022/2022-07-31_Hungarian_Grand_Prix/2022-07-31_Race';
  final _qualiUrl =
      '$_baseUrl/2022/2022-07-31_Hungarian_Grand_Prix/2022-07-30_Qualifying';
  final _carData = 'CarData.z.jsonStream';
  final _posData = 'Position.z.jsonStream';
  final _lapTimes = 'TimingStats.jsonStream';
  final _heartbeatData = 'Heartbeat.jsonStream';

  Future<File> getLivetimingFile(String url) async {
    var fileInfo = await _cacheManager.getFileFromCache(url);
    if (fileInfo != null) {
      return fileInfo.file;
    } else {
      var file = await _cacheManager.getSingleFile(url);
      await _cacheManager.putFile(url, await file.readAsBytes(), key: url);
      return file;
    }
  }

  List<TelemetryEntry> parseCarDataRow(String row) {
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
        carTelemetries[car] = CarTelemetry(carData["2"], carData["0"],
            carData["3"], carData["4"], carData["5"] > 0, carData["45"] > 1);
      }
      telemetries.add(TelemetryEntry(time, carTelemetries));
    }
    return telemetries;
  }

  List<PositionEntry> parsePositionDataRow(String row) {
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

  Future<List<TelemetryEntry>> getTelemetries() async {
    final file = await getLivetimingFile('$_qualiUrl/$_carData');
    final content = await file.readAsLines();
    List<TelemetryEntry> telemetries = [];
    for (var row in content) {
      telemetries.addAll(parseCarDataRow(row));
    }
    return telemetries;
  }

  Future<List<PositionEntry>> getPositions() async {
    final file = await getLivetimingFile('$_qualiUrl/$_posData');
    final content = await file.readAsLines();
    List<PositionEntry> positions = [];
    for (var row in content) {
      positions.addAll(parsePositionDataRow(row));
    }
    return positions;
  }

  Future<Map<String, LapTime>> getPersonalBests() async {
    final file = await getLivetimingFile('$_qualiUrl/$_lapTimes');
    final content = await file.readAsLines();
    Map<String, LapTime> bestTimes = {};
    final startTime = await getSessionStart();
    if (startTime != null) {
      for (var row in content.skip(1)) {
        final ts = LivetimingConversion.parseDuration(row.substring(0, 11));
        if (ts != null) {
          Map<String, dynamic> data = jsonDecode(row.substring(12))["Lines"];
          for (var car in data.keys) {
            final time = data[car]["PersonalBestLapTime"]?["Value"];
            if (time is String) {
              final duration = LivetimingConversion.parseDuration(time);
              if (duration != null &&
                  (!bestTimes.containsKey(car) ||
                      bestTimes[car]!.time.compareTo(duration) > 0)) {
                bestTimes[car] = LapTime(startTime.add(ts), duration);
              }
            }
          }
        }
      }
    }
    return bestTimes;
  }

  Future<DateTime?> getSessionStart() async {
    final heartbeat = await getLivetimingFile('$_qualiUrl/$_heartbeatData');
    final sessionTiming =
        await heartbeat.readAsLines().then((value) => value.first);
    final duration =
        LivetimingConversion.parseDuration(sessionTiming.substring(0, 11));
    final utc =
        DateTime.tryParse(jsonDecode(sessionTiming.substring(12))["Utc"]);
    return duration != null && utc != null ? utc.subtract(duration) : null;
  }
}
