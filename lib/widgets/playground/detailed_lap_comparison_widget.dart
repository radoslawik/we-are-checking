import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hard_tyre/models/data/livetiming/lap_time.dart';
import 'package:hard_tyre/widgets/title_bar_widget.dart';

import '../charts/line_chart_widget.dart';

class DetailedLapComparisonWidget extends StatefulWidget {
  const DetailedLapComparisonWidget({Key? key, required this.comparison}) : super(key: key);
  final LapPositionComparison comparison;

  @override
  State<DetailedLapComparisonWidget> createState() => _DetailedLapComparisonWidgetState();
}

class _DetailedLapComparisonWidgetState extends State<DetailedLapComparisonWidget> {
  late LineChartWidget _graph;
  final _min = 0.0;
  late double _max;
  late int _divisions;
  late double _change;
  late String _currentDur;
  var _current = 0.0;
  var _zoom = false;

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
    setState(() {
      _graph = LineChartWidget(data: widget.comparison.lapPositions, current: Duration(milliseconds: (_current * 1000).ceil()), zoom: _zoom);
    });
  }

  String formatDuration(Duration dur) {
    final minutes = dur.inMinutes;
    final seconds = dur.inSeconds - minutes * 60;
    final ms = dur.inMilliseconds - dur.inSeconds * 1000;
    return '$minutes:${seconds < 10 ? '0' : ''}$seconds.$ms${ms == 0 ? '00' : ''}';
  }

  @override
  void initState() {
    super.initState();
    final times = widget.comparison.lapPositions.map((e) => e.info.time).toList();
    times.sort((a, b) => b.compareTo(a));
    _max = times.first.inSeconds + 1;
    _divisions = (_max * 10).ceil();
    _change = _max / _divisions;
    _currentDur = formatDuration(Duration(milliseconds: (_current * 1000).round()));
    _graph = LineChartWidget(data: widget.comparison.lapPositions, current: Duration(seconds: _current.ceil()), zoom: _zoom);
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
          child: Stack(children: [
            Column(
              children: [
                Row(
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
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: _graph,
                  ),
                ),
              ],
            ),
          ]),
        ));
  }
}
