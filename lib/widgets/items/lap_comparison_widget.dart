import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hard_tyre/models/data/livetiming/position.dart';
import 'package:hard_tyre/widgets/charts/line_chart_widget.dart';
import 'package:hard_tyre/widgets/details/detailed_lap_comparison_widget.dart';
import 'package:hard_tyre/widgets/items/media_item_widget.dart';

class LapComparisonWidget extends MediaItemWidget {
  const LapComparisonWidget({Key? key, required this.comparison})
      : super(key: key);
  final LapPositionComparison comparison;

  @override
  State<LapComparisonWidget> createState() => _LapComparisonWidgetState();
}

class _LapComparisonWidgetState extends State<LapComparisonWidget> {
  List<FlSpot> _convertToChartPoints(List<CarPosition> positions) =>
      positions.map((e) => FlSpot(e.x.toDouble(), e.y.toDouble())).toList();

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _showDetails,
      padding: EdgeInsets.zero,
      color: Colors.white,
      child: SizedBox(
          width: 400,
          height: 400,
          child: LineChartWidget(
              driverOne: _convertToChartPoints(widget.comparison.driverOne),
              driverTwo: _convertToChartPoints(widget.comparison.driverTwo))),
    );
  }

  void _showDetails() => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailedLapComparisonWidget(comparison: widget.comparison)));
}
