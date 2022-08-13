import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hard_tyre/models/data/livetiming/lap_time.dart';
import 'package:hard_tyre/models/data/livetiming/position.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({Key? key, required this.data, required this.current, required this.zoom}) : super(key: key);
  final List<LapPosition> data;
  final Duration current;
  final bool zoom;

  @override
  LineChartWidgetState createState() => LineChartWidgetState();
}

class LineChartWidgetState extends State<LineChartWidget> {
  final List<Color> _colors = [Colors.red, Colors.blue, Colors.green, Colors.purple];
  late List<CarPosition> _lastPositions;
  late List<LineChartBarData> _chartLines;
  double? _minX;
  double? _minY;
  double? _maxX;
  double? _maxY;

  @override
  void initState() {
    super.initState();
    _lastPositions = _getLastPositions();
    _chartLines = getChartLines(widget.data, widget.current);
    updateLimits();
  }

  List<CarPosition> _getLastPositions() {
    List<CarPosition> lastPositions = [];
    for (var lp in widget.data) {
      final key = lp.coords.keys.firstWhere((element) => element >= widget.current, orElse: () => lp.coords.keys.last);
      if (lp.coords[key] != null) {
        lastPositions.add(lp.coords[key]!);
      }
    }
    return lastPositions;
  }

  @override
  void didUpdateWidget(covariant LineChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _lastPositions = _getLastPositions();
      _chartLines = getChartLines(widget.data, widget.current);
    });
    updateLimits();
  }

  void updateLimits() {
    double? minX;
    double? minY;
    double? maxX;
    double? maxY;
    if (widget.zoom) {
      _lastPositions.sort((a, b) => a.x.compareTo(b.x));
      minX = _lastPositions.first.x - 30;
      maxX = _lastPositions.last.x + 30;
      _lastPositions.sort((a, b) => a.y.compareTo(b.y));
      minY = _lastPositions.first.y - 30;
      maxY = _lastPositions.last.y + 30;
    }
    setState(() {
      _minX = minX;
      _minY = minY;
      _maxX = maxX;
      _maxY = maxY;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        child: Padding(
            padding: const EdgeInsets.all(0),
            child: Expanded(
              child: LineChart(
                LineChartData(
                    minX: _minX,
                    maxX: _maxX,
                    minY: _minY,
                    maxY: _maxY,
                    borderData: FlBorderData(show: false),
                    lineTouchData: LineTouchData(enabled: false),
                    clipData: FlClipData.all(),
                    gridData: FlGridData(show: false),
                    lineBarsData: _chartLines,
                    titlesData: FlTitlesData(show: false)),
                swapAnimationCurve: Curves.easeInCirc,
                swapAnimationDuration: const Duration(milliseconds: 300),
              ),
            )));
  }

  LineChartBarData getChartLine(Map<Duration, FlSpot> points, String number, Duration ts, Color color) {
    return LineChartBarData(
      spots: points.values.toList(),
      dotData: FlDotData(checkToShowDot: _shouldDisplayDot),
      color: color,
      barWidth: 1.5,
      isStrokeJoinRound: true,
      isStrokeCapRound: true,
      isCurved: true,
    );
  }

  bool _shouldDisplayDot(FlSpot spot, LineChartBarData barData) {
    return _lastPositions.firstWhereOrNull((element) => element.x.toDouble() == spot.x && element.y.toDouble() == spot.y) != null;
  }

  List<LineChartBarData> getChartLines(List<LapPosition> data, Duration ts) {
    List<LineChartBarData> plots = [];
    for (var lp in data) {
      Map<Duration, FlSpot> points = {};
      for (var time in lp.coords.keys) {
        if (lp.coords[time] != null) {
          points[time] = FlSpot(lp.coords[time]!.x.toDouble(), lp.coords[time]!.y.toDouble());
        }
      }
      plots.add(getChartLine(points, lp.driverNumber, ts, _colors[plots.length]));
    }
    return plots;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
