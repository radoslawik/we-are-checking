import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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
          child: Center(
            child: AspectRatio(
              aspectRatio: 1/1,
              child: LineChartWidget(
                  driverOne: _convertToChartPoints(widget.comparison.driverOne),
                  driverTwo:
                      _convertToChartPoints(widget.comparison.driverTwo)),
            ),
          ),
        ));
  }
}
