import 'package:collection/collection.dart';
import 'package:hard_tyre/models/data/ergast/data.dart';
import 'package:hard_tyre/models/data/ergast/drivers.dart';
import 'package:hard_tyre/models/data/ergast/standings.dart';
import 'package:hard_tyre/services/cache_provider.dart';
import 'package:http/http.dart' as http;

class ErgastDataProvider {
  // Singleton
  static final ErgastDataProvider _singleton = ErgastDataProvider._internal();
  factory ErgastDataProvider() => _singleton;
  ErgastDataProvider._internal();

  final _cacheProvider = CacheProvider();

  final _baseUrl = "https://ergast.com/api/f1";
  final _extension = "json";
  List<Driver>? _drivers;
  List<DriverStanding>? _driverStandings;
  List<ConstructorStanding>? _constructorStandings;

  Future<List<Driver>> getDrivers([int? season, bool forceRefresh = false]) async {
    if (_drivers == null || forceRefresh) {
      final data = await _fetchData("${season ?? "current"}/drivers");
      _drivers = data?.driverTable?.drivers;
    }
    return _drivers ?? List.empty();
  }

  Future<List<DriverStanding>> getDriverStandings([int? season, bool forceRefresh = false]) async {
    if (_driverStandings == null || forceRefresh) {
      final data = await _fetchData("${season ?? "current"}/driverStandings");
      _driverStandings ??= data?.standingsTable?.standingsLists.firstOrNull?.driverStandings;
    }
    return _driverStandings ?? List.empty();
  }

  Future<List<ConstructorStanding>> getConstructorStandings([int? season, bool forceRefresh = false]) async {
    if (_constructorStandings == null || forceRefresh) {
      final data = await _fetchData("${season ?? "current"}/constructorStandings");
      _constructorStandings = data?.standingsTable?.standingsLists.firstOrNull?.constructorStandings;
    }
    return _constructorStandings ?? List.empty();
  }

  Future<MrData?> _fetchData(String complement) async {
    final file = await _cacheProvider.tryGetFile('$_baseUrl/$complement.$_extension', refreshDuration: const Duration(hours: 1), ext: _extension);
    return file != null ? dataFromJson(await file.readAsString()) : null;
  }
}
