import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hard_tyre/models/data/livetiming/lap_time.dart';
import 'package:hard_tyre/models/data/livetiming/position.dart';
import 'package:hard_tyre/widgets/title_bar_widget.dart';

import '../charts/line_chart_widget.dart';

class DetailedLapComparisonWidget extends StatefulWidget {
  const DetailedLapComparisonWidget({Key? key, required this.comparison})
      : super(key: key);
  final LapPositionComparison comparison;

  @override
  State<DetailedLapComparisonWidget> createState() =>
      _DetailedLapComparisonWidgetState();
}

class _DetailedLapComparisonWidgetState
    extends State<DetailedLapComparisonWidget> {
  List<FlSpot> _convertToChartPoints(List<CarPosition> positions) =>
      positions.map((e) => FlSpot(e.x.toDouble(), e.y.toDouble())).toList();

  double _current = 0.0;
  void _updateTime(double value) {
    setState(() {
      _current = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const TitleBarWidget(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            Column(
              children: [
                Slider(
                  value: _current,
                  max: 80.0,
                  divisions: 800,
                  onChanged: _updateTime,
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: LineChartWidget(data: widget.comparison.items),
                  ),
                ),
              ],
            ),
          ]),
        ));
  }
}
