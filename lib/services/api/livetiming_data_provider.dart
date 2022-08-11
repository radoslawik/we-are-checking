import 'dart:convert';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hard_tyre/helpers/livetiming_conversion.dart';
import 'package:hard_tyre/models/data/livetiming/telemetry.dart';

class LivetimingDataProvider {
  static final _cacheManager = DefaultCacheManager();
  static final _url = 'http://livetiming.formula1.com/static/2022/2022-07-31_Hungarian_Grand_Prix/2022-07-31_Race/CarData.z.jsonStream';

  static Future<File> getLivetimingFile() async {
    var fileInfo = await _cacheManager.getFileFromCache(_url);
    if(fileInfo != null)
    {
      return fileInfo.file;
    }
    else
    {
      var file = await _cacheManager.getSingleFile(_url);
      await _cacheManager.putFile(_url, await file.readAsBytes(), key: _url);  
      return file;
    }
  }

  static List<TelemetryEntry> parseCarDataRow(String row){
    final rawInput = row.split('"').elementAt(1);
    final jsonString = LivetimingConversion.decodeToString(rawInput);
    List<dynamic> entries = jsonDecode(jsonString)["Entries"];
    List<TelemetryEntry> telemetries = [];
    for(var entry in entries)
    {
      final time = DateTime.parse(entry["Utc"]);
      Map<String,dynamic> data = entry["Cars"];
      Map<String,CarTelemetry> carTelemetries = {};
      for(var car in data.keys)
      {
        Map<String,dynamic> carData = data[car]["Channels"];
        carTelemetries[car] = CarTelemetry(carData["2"], carData["0"], carData["3"], carData["4"], carData["5"] > 0, carData["45"] > 1);
      }
      telemetries.add(TelemetryEntry(time, carTelemetries));
    }
    return telemetries;
  }

  static Future<List<TelemetryEntry>> getTelemetries() async {
    final file = await getLivetimingFile();
    final content = await file.readAsLines();
    List<TelemetryEntry> telemetries = [];
    for(var row in content){
      telemetries.addAll(parseCarDataRow(row));
    }
    return telemetries;
  }
}