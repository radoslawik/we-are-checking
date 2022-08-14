import 'dart:convert';

import 'circuits.dart';
import 'drivers.dart';
import 'standings.dart';

MrData dataFromJson(String str) => ErgastData.fromJson(json.decode(str)).mrData;

class ErgastData {
    ErgastData({
        required this.mrData,
    });

    MrData mrData;

    factory ErgastData.fromJson(Map<String, dynamic> json) => ErgastData(
        mrData: MrData.fromJson(json["MRData"]),
    );
}

class MrData {
    MrData({
        required this.xmlns,
        required this.series,
        required this.url,
        required this.limit,
        required this.offset,
        required this.total,
        this.driverTable,
        this.standingsTable,
        this.raceTable,
    });

    String xmlns;
    String series;
    String url;
    String limit;
    String offset;
    String total;
    DriverTable? driverTable;
    StandingsTable? standingsTable;
    RaceTable? raceTable;

    factory MrData.fromJson(Map<String, dynamic> json) => MrData(
        xmlns: json["xmlns"],
        series: json["series"],
        url: json["url"],
        limit: json["limit"],
        offset: json["offset"],
        total: json["total"],
        driverTable: json["DriverTable"] != null ? DriverTable.fromJson(json["DriverTable"]) : null,
        standingsTable: json["StandingsTable"] != null ? StandingsTable.fromJson(json["StandingsTable"]) : null,
        raceTable: json["RaceTable"] != null ? RaceTable.fromJson(json["RaceTable"]) : null,
    );
}