import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hard_tyre/models/data/livetiming/lap_time.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({Key? key, required this.data}) : super(key: key);
  final Map<String, List<LapPosition>> data;

  @override
  LineChartWidgetState createState() => LineChartWidgetState();
}

class LineChartWidgetState extends State<LineChartWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Expanded(
                    child: LineChart(
                      LineChartData(
                        /*
                        minY: -300,
                        maxY: 0,
                        minX: -90,
                        maxX: -55,
                        */
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(enabled: false),
                        clipData: FlClipData.none(),
                        gridData: FlGridData(show: false),
                        lineBarsData: getChartLines(widget.data),
                        titlesData: FlTitlesData(show: false)
                        /*
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: leftTitleWidgets,
                              reservedSize: 25,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: bottomTitleWidgets,
                              reservedSize: 20,
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        */
                      ),
                    ),
                  )
                )
        );
  }

  LineChartBarData getChartLine(List<FlSpot> points, String number) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: false,
      ),
      color: number == "1" ? Colors.blue : number == "44" ? Colors.red : Colors.green,
      barWidth: 1.5,
      isCurved: true,
    );
  }

  List<LineChartBarData> getChartLines(Map<String, List<LapPosition>> data) {
    final lps = data.keys.map((e) => data[e]!);
    List<LineChartBarData> plots = [];
    for (var lp in lps)
    {
      final points = lp.map((e) => FlSpot(e.position.x.toDouble(), e.position.y.toDouble())).toList();
      plots.add(getChartLine(points, lp.first.driverNumber));
    }
    return plots;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    return value == meta.min || value == meta.max ?
      Container() : SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(meta.formattedValue, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(meta.formattedValue, style: style),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
  
}