import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hard_tyre/models/data/livetiming/lap_time.dart';
import 'package:hard_tyre/models/media/playground_item.dart';
import 'package:hard_tyre/widgets/items/media_item_widget.dart';
import 'package:hard_tyre/widgets/playground/detailed_lap_comparison_widget.dart';

class PlaygroundItemWidget extends MediaItemWidget {
  const PlaygroundItemWidget({Key? key, required this.item}) : super(key: key);
  final PlaygroundItem item;

  @override
  State<PlaygroundItemWidget> createState() => _PlaygroundItemWidgetState();
}

class _PlaygroundItemWidgetState extends State<PlaygroundItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: MaterialButton(
            onPressed: _showDetails,
            padding: EdgeInsets.zero,
            color: Colors.white,
            child: Row(children: [
              SizedBox(
                width: 150,
                child: LineChart(
                  LineChartData(
                      minX: -1,
                      maxX: 1,
                      minY: -1,
                      maxY: 0.8,
                      borderData: FlBorderData(show: false),
                      lineTouchData: LineTouchData(enabled: false),
                      clipData: FlClipData.all(),
                      gridData: FlGridData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [FlSpot(-0.7,-0.6), FlSpot(-0.4, 0.2), FlSpot(0.3, 0.4), FlSpot(0.7, -0.2)],
                          show: true,
                          color: Colors.blue,
                          barWidth: 1.5,
                          isCurved: true,
                          isStrokeCapRound: true,
                          isStrokeJoinRound: true,
                          curveSmoothness: 0.25
                        ),
                        LineChartBarData(
                          spots: const [FlSpot(-0.6,-0.7), FlSpot(-0.5, 0.1), FlSpot(0.1, 0.5), FlSpot(0.6, -0.1)],
                          show: true,
                          color: Colors.red,
                          barWidth: 1.5,
                          isCurved: true,
                          isStrokeCapRound: true,
                          isStrokeJoinRound: true,
                          curveSmoothness: 0.25
                        ),
                      ],
                  titlesData: FlTitlesData(show: false)),
                  swapAnimationCurve: Curves.easeInCirc,
                  swapAnimationDuration: const Duration(milliseconds: 300),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(widget.item.title.replaceAll(RegExp(r' '), '\n'), style: Theme.of(context).textTheme.subtitle1),
              )
            ],)
          ),
        ),
      ),
    );
  
  }

  void _showDetails() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              DetailedPlaygroundItemWidget(item: widget.item)));
}

class DetailedPlaygroundItemWidget extends StatefulWidget {
  const DetailedPlaygroundItemWidget({Key? key, required this.item})
      : super(key: key);
  final PlaygroundItem item;

  @override
  State<DetailedPlaygroundItemWidget> createState() =>
      _DetailedPlaygroundItemWidgetState();
}

class _DetailedPlaygroundItemWidgetState
    extends State<DetailedPlaygroundItemWidget> {
  DetailedPlaygroundItem? detail;

  Future<DetailedPlaygroundItem> getDetail() async => await widget.item.getData();

  @override
  void initState() {
    super.initState();
    getDetail().then((value) => setState(() {
      detail = value;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return _getSpecificWidget();
  }

  Widget _getSpecificWidget() {
    if (detail == null) {
      const SizedBox(
          width: 150,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: CircularProgressIndicator(),
          ));
    } else if (detail is LapPositionComparison) {
      return DetailedLapComparisonWidget(
          comparison: detail as LapPositionComparison);
    }
    return Container();
  }
}
