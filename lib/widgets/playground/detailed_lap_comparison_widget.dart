import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hard_tyre/models/data/ergast/circuits.dart';
import 'package:hard_tyre/models/data/ergast/drivers.dart';
import 'package:hard_tyre/models/data/livetiming/lap_time.dart';
import 'package:hard_tyre/services/api/ergast_data_provider.dart';
import 'package:hard_tyre/services/api/livetiming_data_provider.dart';
import 'package:hard_tyre/services/image_source_provider.dart';
import 'package:hard_tyre/widgets/title_bar_widget.dart';

import '../charts/line_chart_widget.dart';

class DetailedLapComparisonWidget extends StatefulWidget {
  const DetailedLapComparisonWidget({Key? key, required this.comparison}) : super(key: key);
  final LapPositionComparison comparison;

  @override
  State<DetailedLapComparisonWidget> createState() => _DetailedLapComparisonWidgetState();
}

class _DetailedLapComparisonWidgetState extends State<DetailedLapComparisonWidget> {
  final _ergast = ErgastDataProvider();
  final _livetiming = LivetimingDataProvider();
  List<Race>? _races;
  List<Driver>? _drivers;
  String? _selectedRaceName;
  Race? _selectedRace;
  String _circuitImage = "";
  String? _selectedDriver1;
  String? _selectedDriver2;
  List<LapPosition>? _lapPositions;

  LineChartWidget? _graph;
  final _min = 0.0;
  double _max = 99.0;
  int _divisions = 990;
  double _change = 0.1;
  String _currentDur = "Unknown";
  var _current = 0.0;
  var _zoom = false;
  var _dataReady = false;
  var _isLoading = false;

  void init() async {
    final races = await _ergast.getRaceSchedule();
    final finished = races.where((element) => element.date.compareTo(DateTime.now()) < 0).toList();
    final drivers = await _ergast.getDrivers();
    setState(() {
      _races = finished;
      _drivers = drivers;
    });
  }

  void _updateTime(double value) {
    final dur = Duration(milliseconds: (value * 1000).round());
    setState(() {
      _current = value;
      _currentDur = formatDuration(dur);
    });
    updateGraph();
  }

  void _updateZoom() {
    setState(() {
      _zoom ^= true;
    });
    updateGraph();
  }

  void updateGraph() {
    if (_lapPositions != null && _lapPositions!.length >= 2) {
      setState(() {
        _graph = LineChartWidget(data: _lapPositions!, current: Duration(milliseconds: (_current * 1000).round()), zoom: _zoom);
      });
    }
  }

  String formatDuration(Duration dur) {
    final minutes = dur.inMinutes;
    final seconds = dur.inSeconds - minutes * 60;
    final ms = dur.inMilliseconds - dur.inSeconds * 1000;
    return '$minutes:${seconds < 10 ? '0' : ''}$seconds.$ms${ms == 0 ? '00' : ''}';
  }

  void _selectedRaceChanged(String? race) async {
    final selectedRace = _races!.firstWhere((element) => element.raceName == race);
    final imageFile = ImageSourceProvider.getCircuitImageSource(selectedRace.circuit.circuitId);
    setState(() {
      _selectedRaceName = race;
      _selectedRace = selectedRace;
      _circuitImage = imageFile;
    });
    _tryInitialize();
  }

  void _selectedDriver1Changed(String? d1) {
    setState(() {
      _selectedDriver1 = d1;    
    });
    _tryInitialize();
  }

  void _selectedDriver2Changed(String? d2) {
    setState(() {
      _selectedDriver2 = d2;
    });
    _tryInitialize();
  }

  void _tryInitialize() async {
    if (_selectedRace != null && _selectedDriver1 != null && _selectedDriver2 != null) {
      _isLoading = true;
      final d1 = await _livetiming.getPositionsDuringPersonalBest(_selectedDriver1!, _selectedRace!);
      final d2 = await _livetiming.getPositionsDuringPersonalBest(_selectedDriver2!, _selectedRace!);
      if (d1 != null && d2 != null) {
        _lapPositions = [d1, d2];
        final times = _lapPositions!.map((e) => e.info.time).toList();
        times.sort((a, b) => b.compareTo(a));
        setState(() {
          _zoom = false;
          _current = 0.0;
          _max = times.first.inSeconds + 1;
          _divisions = (_max * 10).ceil();
          _change = _max / _divisions;
          _currentDur = formatDuration(Duration(milliseconds: (_current * 1000).round()));
          _graph = LineChartWidget(data: _lapPositions!, current: Duration(milliseconds: (_current * 1000).round()), zoom: _zoom);
        });
        _dataReady = true;
        _isLoading = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const TitleBarWidget(),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AbsorbPointer(
              absorbing: _isLoading,
              child: Stack(children: [
                Column(
                  children: [
                    Row(children: [
                      Image.network(_circuitImage,
                                errorBuilder: (c, o, s) => const Text('error'))
                    ],),
                    Row(
                      children: [
                        DropdownButton(
                            items: _races
                                ?.map((e) => DropdownMenuItem(
                                      value: e.raceName,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(e.circuit.circuitName),
                                          Text(
                                            e.raceName,
                                            style: Theme.of(context).textTheme.caption,
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            value: _selectedRaceName,
                            onChanged: _selectedRaceChanged,
                            hint: const Text("Circuit")),
                        const SizedBox(width: 20),
                        DropdownButton(
                            items: _drivers
                                ?.where((element) => element.getDriverNumber() != _selectedDriver2)
                                .toList()
                                .map((e) => DropdownMenuItem(
                                      value: e.getDriverNumber(),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(e.familyName),
                                          Text(
                                            e.givenName,
                                            style: Theme.of(context).textTheme.caption,
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            value: _selectedDriver1,
                            onChanged: _selectedDriver1Changed,
                            hint: const Text("Driver 1")),
                        const SizedBox(width: 20),
                        DropdownButton(
                            items: _drivers
                                ?.where((element) => element.getDriverNumber() != _selectedDriver1)
                                .toList()
                                .map((e) => DropdownMenuItem(
                                      value: e.getDriverNumber(),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(e.familyName),
                                          Text(
                                            e.givenName,
                                            style: Theme.of(context).textTheme.caption,
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            value: _selectedDriver2,
                            onChanged: _selectedDriver2Changed,
                            hint: const Text("Driver 2")),
                      ],
                    ),
                    _dataReady
                        ? Row(
                            children: [
                              MaterialButton(onPressed: _updateZoom, child: const Text('Toggle zoom')),
                              MaterialButton(onPressed: () => _updateTime(max(_current - _change, _min)), child: const Text('Previous')),
                              Slider(
                                value: _current,
                                min: _min,
                                max: _max,
                                divisions: _divisions,
                                onChanged: _updateTime,
                              ),
                              MaterialButton(onPressed: () => _updateTime(min(_current + _change, _max)), child: const Text('Next')),
                              Text(_currentDur),
                            ],
                          )
                        : Container(),
                  ],
                ),
                Row(
                  children: [
                    _dataReady
                        ? Padding(
                            padding: const EdgeInsets.only(top: 100.0),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: _graph,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ]),
            )));
  }
}
