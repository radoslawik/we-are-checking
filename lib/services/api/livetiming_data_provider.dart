import 'dart:convert';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hard_tyre/helpers/livetiming_conversion.dart';
import 'package:hard_tyre/models/data/livetiming/position.dart';
import 'package:hard_tyre/models/data/livetiming/telemetry.dart';

class LivetimingDataProvider {
  static final _cacheManager = DefaultCacheManager();
  static const _url =
      'http://livetiming.formula1.com/static/2022/2022-07-31_Hungarian_Grand_Prix/2022-07-31_Race/';
  static const _carData = 'CarData.z.jsonStream';
  static const _posData = 'Position.z.jsonStream';

  static Future<File> getLivetimingFile(String url) async {
    var fileInfo = await _cacheManager.getFileFromCache(url);
    if (fileInfo != null) {
      return fileInfo.file;
    } else {
      var file = await _cacheManager.getSingleFile(url);
      await _cacheManager.putFile(url, await file.readAsBytes(), key: url);
      return file;
    }
  }

  static List<TelemetryEntry> parseCarDataRow(String row) {
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

  static List<PositionEntry> parsePositionDataRow(String row) {
    final rawInput = row.split('"').elementAt(1);
    final jsonString = LivetimingConversion.decodeToString(rawInput);
    List<dynamic> entries = jsonDecode(jsonString)["Position"];
    List<PositionEntry> positions = [];
    for (var entry in entries) {
      final time = DateTime.parse(entry["Timestamp"]);
      Map<String, dynamic> data = entry["Entries"];
      Map<String, CarPosition> carPositions = {};
      for (var car in data.keys){
        final d = data[car];
        carPositions[car] = CarPosition(d["Status"], d["X"], d["Y"], d["Z"]);
      }
      positions.add(PositionEntry(time, carPositions));
    }
    return positions;
  }

  static Future<List<TelemetryEntry>> getTelemetries() async {
    final file = await getLivetimingFile('$_url$_carData');
    final content = await file.readAsLines();
    List<TelemetryEntry> telemetries = [];
    for (var row in content) {
      telemetries.addAll(parseCarDataRow(row));
    }
    return telemetries;
  }

  static Future<List<PositionEntry>> getPositions() async {
    final file = await getLivetimingFile('$_url$_posData');
    final content = await file.readAsLines();
    List<PositionEntry> positions = [];
    for (var row in content) {
      positions.addAll(parsePositionDataRow(row));
    }
    return positions;
  }
}
