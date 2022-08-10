import 'package:collection/collection.dart';
import 'package:hard_tyre/models/data/ergast/data.dart';
import 'package:hard_tyre/models/data/ergast/drivers.dart';
import 'package:hard_tyre/models/data/ergast/standings.dart';
import 'package:http/http.dart' as http;

class ErgastDataProvider {
  static const String _baseUrl = "https://ergast.com/api/f1";
  static const String _extension = "json";
  static List<Driver>? _drivers;
  static List<DriverStanding>? _driverStandings;
  static List<ConstructorStanding>? _constructorStandings;

  static Future<List<Driver>> getDrivers(
      [int? season, bool forceRefresh = false]) async {
    if (_drivers == null || forceRefresh) {
      final data = await _fetchData("${season ?? "current"}/drivers");
      _drivers = data?.driverTable?.drivers;
    }
    return _drivers ?? List.empty();
  }

  static Future<List<DriverStanding>> getDriverStandings(
      [int? season, bool forceRefresh = false]) async {
    if (_driverStandings == null || forceRefresh) {
      final data = await _fetchData("${season ?? "current"}/driverStandings");
      _driverStandings ??=
          data?.standingsTable?.standingsLists.firstOrNull?.driverStandings;
    }
    return _driverStandings ?? List.empty();
  }

  static Future<List<ConstructorStanding>> getConstructorStandings(
      [int? season, bool forceRefresh = false]) async {
    if (_constructorStandings == null || forceRefresh) {
      final data =
          await _fetchData("${season ?? "current"}/constructorStandings");
      _constructorStandings = data
          ?.standingsTable?.standingsLists.firstOrNull?.constructorStandings;
    }
    return _constructorStandings ?? List.empty();
  }

  static Future<MrData?> _fetchData(String complement) async {
    final response =
        await http.get(Uri.parse("$_baseUrl/$complement.$_extension"));
    return response.statusCode == 200 ? dataFromJson(response.body) : null;
  }
}
