import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({Key? key, required this.driverOne, required this.driverTwo}) : super(key: key);
  final List<FlSpot> driverOne;
  final List<FlSpot> driverTwo;

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
    return widget.driverOne.isNotEmpty
        ? Card(
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
                        lineBarsData: [
                          getChartLine(widget.driverOne, Colors.red),
                          getChartLine(widget.driverTwo, Colors.blue),
                        ],
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
        )
        : Container();
  }

  LineChartBarData getChartLine(List<FlSpot> points, Color color) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: false,
      ),
      color: color,
      barWidth: 1.5,
      isCurved: true,
    );
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